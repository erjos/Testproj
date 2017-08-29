import UIKit

class ViewController: UIViewController {
    
    //APP TODO
    //- make dividers on table view for main page the same color as the stroke dividers on the editor page
    
    //- add info popup to the editor that describes tags: "Think of tags as collections or folders you can use to order and quickly retrieve your saved entries. You can add multiple tags to your entries and create new custom tags. You can view your entries by tag and search for them as well."
    
    //- create function to create custom tags
    
    //- design and build schema for core data
    
    //- Tab bar on main page to display multiple views of data: table view of chronological order, collection view of tags/folders, etc.
    
    //- add shadows where applicable to make the UI pop more (i.e. around the tags that are selected to portray a pressed button to the user
    
    //- logo of a horizontal pencil that sits in the nav bar
    
    //- youtube style tab bar under the nav bar on the main page - white selector bar with dropshadow under it display which tab is selected - title on the left hand side of the nav bar provide a label

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "Pencil")
        imageView.image = logo
        self.navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
