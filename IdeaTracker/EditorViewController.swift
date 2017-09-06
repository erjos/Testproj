import UIKit
import RealmSwift

class EditorViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var titleField: UITextField!
    
    fileprivate let reuseIdentifier = "TagCell"
    
    let COLOR_LIGHT_GRAY_TEXT = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 255/255)
    let COLOR_DARK_GRAY_TEXT = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 255/255)
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let entry = Entry()
        
        entry.name = titleField.text!
        entry.notes = notesTextView.text
        
        let realm = try! Realm()
        
        //TODO: add error handling for if the device runs out of disk space
        try! realm.write {
            realm.add(entry)
        }
    }
    
    
    let defaultTags = ["Book", "Movie", "Quote", "Idea", "Technology", "Product", "Marketing", "Work", "Random", "Fun"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "Pencil")
        imageView.image = logo
        self.navigationItem.titleView = imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleLongPress(_ sender: UIGestureRecognizer){
        let cell = sender.view as! TagCollectionViewCell
        
        let tagEditorVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tagEditor") as? TagEditorViewController
        
        tagEditorVC?.tagName = cell.button.titleLabel?.text
//        tagEditorVC?.buttonTitle = "Save"
        tagEditorVC?.isDeleteHidden = false
        self.navigationController?.present(tagEditorVC!, animated: true, completion:nil)
    }
}

extension EditorViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultTags.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TagCollectionViewCell
        
        var title: String
        if (indexPath.row == defaultTags.count){
            cell.button.tagButtonDelegate = self
            title = "+"
        } else {
            //Gesture Config
            let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
            
            //play with duration to get the right time
            pressGesture.minimumPressDuration = 0.7
            pressGesture.delaysTouchesBegan = true
            cell.addGestureRecognizer(pressGesture)
            title = defaultTags[indexPath.row]
        }
        cell.button.setTitle(title, for: .normal)
        cell.backgroundColor = UIColor.clear
        
        // Configure the cell
        return cell
    }
}

extension EditorViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var standardTagWidth: CGFloat = 30
        let standardTagHeight: CGFloat = 30
        
        //TODO:Encapsulate in method
        if(indexPath.row != (defaultTags.count)){
            let tagLength = CGFloat(defaultTags[indexPath.row].characters.count)
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
        if(textView.text == "Notes..."){
            textView.text = ""
            textView.textColor = COLOR_DARK_GRAY_TEXT

        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            textView.text = "Notes..."
            
            //TODO:Light gray color for placeholder text in the UITextView is off from Title TextField
            textView.textColor = COLOR_LIGHT_GRAY_TEXT
        }
    }
}

extension EditorViewController: TagButtonDelegate{
    func didSelectAddTag(tagButton: TagButton) {
        let tagEditorVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tagEditor")
        
        self.navigationController?.present(tagEditorVC, animated: true, completion: nil)
    }
}
