import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNotesView()
    }
    
    private func styleNotesView(){
        notesTextView.clipsToBounds = true
        notesTextView.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
