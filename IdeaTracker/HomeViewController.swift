import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    var entries: Results<Entry>?
    
    //should always be nil unless a user clicks an entry from the table
    var selectedEntry: Entry?

    @IBOutlet weak var entryTableView: UITableView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    //All the tag stuff
    fileprivate let TAG_COLLECTION_CELL_XIB = "TagCollectionViewCell"
    fileprivate let STORYBOARD_MAIN = "Main"
    fileprivate let reuseIdentifier = "TagCell"
    fileprivate let ID_TAG_EDITOR_VC = "tagEditor"
    fileprivate let TAG_LABEL_ADD = "+"
    
    var defaultTags: Results<Tag>?
    var selectedTag: Tag?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "Pencil")
        imageView.image = logo
        self.navigationItem.titleView = imageView
        
        entryTableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        entryTableView.separatorColor = UIColor(red: 119/255, green: 83/255, blue: 50/255, alpha: 255/255)
        
        //tag stuff
        let realm = try! Realm()
        defaultTags = realm.objects(Tag.self)
        self.tagCollectionView.register(UINib(nibName: TAG_COLLECTION_CELL_XIB, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Might not need this, but should test what happens w/o it
        self.selectedEntry = nil
        
        //TODO: add error handling for the first initialization of this realm instance
        let realm = try! Realm()
        entries = realm.objects(Entry.self)
        entryTableView.reloadData()
        self.tagCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEditorVC"){
            let vc = segue.destination as! EditorViewController
            vc.selectedEntry = self.selectedEntry
        }
    }
    
    //repeated code from Editor VC
    @objc func handleLongPress(_ sender: UIGestureRecognizer){
        let cell = sender.view as! TagCollectionViewCell
        let tagEditorVC = UIStoryboard.init(name: STORYBOARD_MAIN, bundle: nil).instantiateViewController(withIdentifier: ID_TAG_EDITOR_VC) as? TagEditorViewController
        //tagEditorVC?.tagName = cell.button.titleLabel?.text
        let tagName = cell.cellLabel.text
        let tag = defaultTags?.filter("name == %@", tagName!).first
        tagEditorVC?.selectedTag = tag
        tagEditorVC?.isDeleteHidden = false
        self.navigationController?.present(tagEditorVC!, animated: true, completion:nil)
    }
    
    //Common
    func setupLongPressGesture() -> UIGestureRecognizer{
        //Gesture Config
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        pressGesture.cancelsTouchesInView = false
        //play with duration to get the right time
        pressGesture.minimumPressDuration = 0.7
        pressGesture.delaysTouchesBegan = true
        return pressGesture
    }
    
    //common
    func setupFinalCell(cell: TagCollectionViewCell) -> TagCollectionViewCell{
        cell.entryCount.isHidden = true
        cell.tagCellDelegate = self
        cell.cellLabel.text = TAG_LABEL_ADD
        return cell
    }
    
    //common
    func setupNormalCells(cell: TagCollectionViewCell, indexPath: IndexPath) -> TagCollectionViewCell{
        cell.addGestureRecognizer(setupLongPressGesture())
        cell.cellLabel.text = (defaultTags?[indexPath.row].name)!
        cell.entryCount.text = defaultTags?[indexPath.row].entries.count.description
        return cell
    }
}

extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(selectedTag != nil){
            let realm = try! Realm()
            entries = realm.objects(Entry.self).filter("ANY tags.name == %@", self.selectedTag?.name)
        }
        return (entries?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var entry: Entry?
        
        entry = entries?[indexPath.row]
        
        guard let currentEntry = entry else {
            return EntryTableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EntryTableViewCell
        cell.entryName.text = currentEntry.name
        return cell
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry = entries?[indexPath.row]
        self.performSegue(withIdentifier: "toEditorVC", sender: self)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        if(item.cellLabel.text! == TAG_LABEL_ADD){
            item.addButtonTapped()
            return
        }
        
        //TODO: need to address the issue of selecting multiple tags at once, maybe change selected tag to selected tags list
        //set selected tag to nil if the tag is deselected
        item.updateTagState()
        if(item.isTagActive){
            let tagName = item.cellLabel.text
            let tag = defaultTags?.filter("name == %@", tagName!).first
            selectedTag = tag!
        } else {
            selectedTag = nil
            //repeated code
            let realm = try! Realm()
            entries = realm.objects(Entry.self)
        }
        
        self.entryTableView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var standardTagWidth: CGFloat = 80
        let standardTagHeight: CGFloat = 30
        //TODO:Encapsulate in method
//        if(indexPath.row != (defaultTags?.count)){
//            let tagLength = CGFloat((defaultTags?[indexPath.row].name.characters.count)!)
//            if(tagLength > 3){
//                let diff:CGFloat = tagLength - 3
//                let space:CGFloat = diff * 10
//                standardTagWidth = 30 + space
//            }
//        }
        return CGSize(width: standardTagWidth, height: standardTagHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultTags!.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TagCollectionViewCell
        let isFinalCell = (indexPath.row == defaultTags?.count)
        _ = isFinalCell ? setupFinalCell(cell: cell) : setupNormalCells(cell: cell, indexPath: indexPath)
        return cell
    }
}

extension HomeViewController: TagCellDelegate{
    func didSelectAddTag(tagCell: TagCollectionViewCell) {
        let tagEditorVC = UIStoryboard.init(name: STORYBOARD_MAIN, bundle: nil).instantiateViewController(withIdentifier: ID_TAG_EDITOR_VC)
        self.present(tagEditorVC, animated: true, completion: nil)
    }
}

//APP TODOS

// - Add Header to the table view - or style the space better

//- add info popup to the editor that describes tags: "Think of tags as collections or folders you can use to order and quickly retrieve your saved entries. You can add multiple tags to your entries and create new custom tags. You can view your entries by tag and search for them as well."

//- Tab bar on main page to display multiple views of data: table view of chronological order, collection view of tags/folders, etc.

//- add shadows where applicable to make the UI pop more (i.e. around the tags that are selected to portray a pressed button to the user

//- youtube style tab bar under the nav bar on the main page - white selector bar with dropshadow under it display which tab is selected - title on the left hand side of the nav bar provide a label
