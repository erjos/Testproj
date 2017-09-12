import UIKit
import RealmSwift

class TagEditorViewController: UIViewController {
    
    var tagName: String?
    var buttonTitle: String?
    var isDeleteHidden: Bool = true
    
    var selectedTag: Tag?
    
    @IBOutlet weak var tagNameField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //TODO: add delete function for the tags - see how it affects the overall entry object...
    
    @IBAction func saveAction(_ sender: Any) {
        
        if let tag = tagName {
            //update the tag name in realm
            //before we do this, create primary key ID's for tags - so that we can update the tag name without borking everything else
            return
        }
        
        if let tagName = tagNameField.text{
            let realm = try! Realm()
            
            //Should do a whitespace trim of the tagName just to be safe
            if(realm.objects(Tag.self).filter("name == %@", tagName).count == 0){
                let tag = Tag()
                tag.name = tagName
                try! realm.write {
                    realm.add(tag)
                }
            } else {
                //present an alert that the tag name already exists
                let alertController = UIAlertController(title: "Tag already exists.", message: "choose a different name", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                self.tagNameField.text = ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tag = selectedTag{
            tagNameField.text = tag.name
        }
        if let button = buttonTitle{
            saveButton.setTitle(button, for: .normal)
        }
        deleteButton.isHidden = isDeleteHidden
    }
}
