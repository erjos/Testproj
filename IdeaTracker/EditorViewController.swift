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
    fileprivate let COLOR_LIGHT_GRAY_TEXT = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 255/255)
    fileprivate let COLOR_DARK_GRAY_TEXT = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 255/255)
    
    //Realm Objects
    var selectedEntry: Entry?
    var selectedTags = List<Tag>()
    var defaultTags: Results<Tag>?
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let realm = try! Realm()
        guard let entry = selectedEntry else {
            let entry = Entry()
            updateEntry(entry)
            //TODO: add error handling for if the device runs out of disk space
            try! realm.write {
                realm.add(entry)
            }
            return
        }
        
        try! realm.write {
            updateEntry(entry)
        }
    }
    
    private func updateEntry(_ entry: Entry) {
        //which tags are active...
        
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
        
        if let currentEntry = selectedEntry {
            self.titleField.text = currentEntry.name
            self.notesTextView.text = currentEntry.notes
            self.notesTextView.textColor = COLOR_DARK_GRAY_TEXT
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
    
    func handleLongPress(_ sender: UIGestureRecognizer){
        let cell = sender.view as! TagCollectionViewCell
        let tagEditorVC = UIStoryboard.init(name: STORYBOARD_MAIN, bundle: nil).instantiateViewController(withIdentifier: ID_TAG_EDITOR_VC) as? TagEditorViewController
        //tagEditorVC?.tagName = cell.button.titleLabel?.text
        let tagName = cell.cellLabel.text
        //TODO: need to make sure only one tag per name can be saved...
        let tag = defaultTags?.filter("name == %@", tagName!).first
        tagEditorVC?.selectedTag = tag
        tagEditorVC?.isDeleteHidden = false
        self.navigationController?.present(tagEditorVC!, animated: true, completion:nil)
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
        var title: String
        if (indexPath.row == defaultTags?.count){
            //cell.button.tagButtonDelegate = self
            title = "+"
        } else {
            //Gesture Config
//            let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
//            
//            
//            pressGesture.cancelsTouchesInView = false
//            
//            //play with duration to get the right time
//            pressGesture.minimumPressDuration = 0.7
//            pressGesture.delaysTouchesBegan = true
//            cell.addGestureRecognizer(pressGesture)
            title = (defaultTags?[indexPath.row].name)!
        }
        cell.cellLabel.text = title
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

extension EditorViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        item.handleTap()
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

//extension EditorViewController: TagButtonDelegate{
//    func didSelectTag() {
//        let tagEditorVC = UIStoryboard.init(name: STORYBOARD_MAIN, bundle: nil).instantiateViewController(withIdentifier: ID_TAG_EDITOR_VC)
//    }
//    
//    func didSelectAddTag(tagButton: TagButton) {
//        let tagEditorVC = UIStoryboard.init(name: STORYBOARD_MAIN, bundle: nil).instantiateViewController(withIdentifier: ID_TAG_EDITOR_VC)
//        self.navigationController?.present(tagEditorVC, animated: true, completion: nil)
//    }
//}
