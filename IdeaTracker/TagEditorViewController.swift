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
    
    @IBAction func saveAction(_ sender: Any) {
        
        if let tag = tagName {
            //update the tag name in realm
        }
        
        if let tagName = tagNameField.text{
            //save the new tag to realm
            let realm = try! Realm()
            let tag = Tag()
            tag.name = tagName
            
            try! realm.write {
                realm.add(tag)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
