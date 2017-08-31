import UIKit

class TagEditorViewController: UIViewController {
    var tagName: String?
    var buttonTitle: String?
    var isDeleteHidden: Bool = false
    
    @IBOutlet weak var tagNameField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
       @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tag = tagName{
            tagNameField.text = tag
        }
        
        if let button = buttonTitle{
            addButton.setTitle(button, for: .normal)
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
