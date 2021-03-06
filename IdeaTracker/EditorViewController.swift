import UIKit
import RealmSwift

class EditorViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var titleField: UITextField!
    
    //CONSTANTS
    fileprivate let reuseIdentifier = "TagCell"
    fileprivate let NOTES_PLACEHOLDER = "Notes..."
    fileprivate let TAG_COLLECTION_CELL_XIB = "TagCollectionViewCell"
    fileprivate let ID_TAG_EDITOR_VC = "tagEditor"
    fileprivate let STORYBOARD_MAIN = "Main"
    fileprivate let IMAGE_PENCIL = "Pencil"
    fileprivate let TAG_LABEL_ADD = "+"
    fileprivate let COLOR_LIGHT_GRAY_TEXT = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 255/255)
    fileprivate let COLOR_DARK_GRAY_TEXT = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 255/255)
    
    //Realm Objects
    var selectedEntry: Entry?
    var newEntry: Entry?
    var selectedTags = List<Tag>()
    var defaultTags: Results<Tag>?
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let realm = try! Realm()
        
        //TODO: test that this is nil in the case of a new entry
        if let update = selectedEntry {
            try! realm.write {
                updateEntry(update)
            }
        }
        
        //TODO: test that this is nil in the case of a selected entry
        if let new = newEntry {
            updateEntry(new)
            //TODO: add error handling for if the device runs out of disk space
            try! realm.write {
                realm.add(new)
            }
        }
    }
    
    private func updateEntry(_ entry: Entry) {
        entry.name = titleField.text!
        entry.notes = notesTextView.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: TAG_COLLECTION_CELL_XIB, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: IMAGE_PENCIL)
        imageView.image = logo
        self.navigationItem.titleView = imageView
        
        //If the selected entry is nil, then instantiate the new entry...
        if let currentEntry = selectedEntry {
            self.titleField.text = currentEntry.name
            self.notesTextView.text = currentEntry.notes
            self.notesTextView.textColor = COLOR_DARK_GRAY_TEXT
        } else {
            newEntry = Entry()
        }
        
        let realm = try! Realm()
        defaultTags = realm.objects(Tag.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Common
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
    
    //Check if a cell title matches with current tags stored on an entry
    func isTagActive(entry: Entry, title: String) -> Bool {
        let isActive = entry.tags.contains(where: { (tag) -> Bool in
            tag.name == title
        })
        return isActive
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
        cell.entryCount.isHidden = true
        cell.addGestureRecognizer(setupLongPressGesture())
        cell.cellLabel.text = (defaultTags?[indexPath.row].name)!
        return cell
    }
    
    func addTagsToEntry(tag: Tag, realm: Realm){
        if let update = selectedEntry {
            try! realm.write {
                update.tags.append(tag)
            }
        }
        if let new = newEntry {
            new.tags.append(tag)
        }
    }
    
    func removeTagsFromEntry(tag: Tag, realm: Realm){
        if let update = selectedEntry {
            let index = update.tags.index(of: tag)
            try! realm.write{
                update.tags.remove(at: index!)
            }
        }
        if let new = newEntry {
            let index = new.tags.index(of: tag)
            new.tags.remove(at: index!)
        }
    }
}

extension EditorViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultTags!.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TagCollectionViewCell
        
        let isFinalCell = (indexPath.row == defaultTags?.count)
        
        _ = isFinalCell ? setupFinalCell(cell: cell) : setupNormalCells(cell: cell, indexPath: indexPath)
        
        //Different from TagViewController
        if let updateEntry = selectedEntry{
            cell.isTagActive = isTagActive(entry: updateEntry, title: cell.cellLabel.text!)
            cell.background.backgroundColor = cell.isTagActive ? cell.selectedColor : cell.defaultColor
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

extension EditorViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        let realm = try! Realm()
        
        if(item.cellLabel.text! == TAG_LABEL_ADD){
            item.addButtonTapped()
            return
        }
        
        item.updateTagState()
        
        guard let tag = defaultTags?[indexPath.row] else{
            return
        }
        
        _ = item.isTagActive ? addTagsToEntry(tag: tag, realm: realm) : removeTagsFromEntry(tag: tag, realm: realm)
    }
}

extension EditorViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var standardTagWidth: CGFloat = 30
        let standardTagHeight: CGFloat = 30
        //TODO:Encapsulate in method
        if(indexPath.row != (defaultTags?.count)){
            let tagLength = CGFloat((defaultTags?[indexPath.row].name.characters.count)!)
            if(tagLength > 3){
                let diff:CGFloat = tagLength - 3
                let space:CGFloat = diff * 10
                standardTagWidth = 30 + space
            }
        }
        return CGSize(width: standardTagWidth, height: standardTagHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
}

//TODO: subclass textView to contain these characteristics, make the placeholder behave the same as the textField(doesn't dissappear until you start typing
extension EditorViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == NOTES_PLACEHOLDER){
            textView.text = ""
            textView.textColor = COLOR_DARK_GRAY_TEXT
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            textView.text = NOTES_PLACEHOLDER
            
            //TODO:Light gray color for placeholder text in the UITextView is off from Title TextField
            textView.textColor = COLOR_LIGHT_GRAY_TEXT
        }
    }
}

extension EditorViewController: TagCellDelegate{
    func didSelectAddTag(tagCell: TagCollectionViewCell) {
        let tagEditorVC = UIStoryboard.init(name: STORYBOARD_MAIN, bundle: nil).instantiateViewController(withIdentifier: ID_TAG_EDITOR_VC)
        self.navigationController?.present(tagEditorVC, animated: true, completion: nil)
    }
}
