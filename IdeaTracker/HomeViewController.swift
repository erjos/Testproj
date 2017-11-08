import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    var entries: Results<Entry>?
    
    //should always be nil unless a user clicks an entry from the table
    var selectedEntry: Entry?

    @IBOutlet weak var entryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "Pencil")
        imageView.image = logo
        self.navigationItem.titleView = imageView
        
        entryTableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        entryTableView.separatorColor = UIColor(red: 119/255, green: 83/255, blue: 50/255, alpha: 255/255)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Might not need this, but should test what happens w/o it
        self.selectedEntry = nil
        
        //TODO: add error handling for the first initialization of this realm instance
        let realm = try! Realm()
        entries = realm.objects(Entry.self)
        entryTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toEditorVC"){
            let vc = segue.destination as! EditorViewController
            vc.selectedEntry = self.selectedEntry
        }
    }
}

extension HomeViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (entries?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = entries?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EntryTableViewCell
        cell.entryName.text = entry?.name
        return cell
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry = entries?[indexPath.row]
        self.performSegue(withIdentifier: "toEditorVC", sender: self)
    }
}

//APP TODOS

// - Add Header to the table view - or style the space better

//- add info popup to the editor that describes tags: "Think of tags as collections or folders you can use to order and quickly retrieve your saved entries. You can add multiple tags to your entries and create new custom tags. You can view your entries by tag and search for them as well."

//- Tab bar on main page to display multiple views of data: table view of chronological order, collection view of tags/folders, etc.

//- add shadows where applicable to make the UI pop more (i.e. around the tags that are selected to portray a pressed button to the user

//- youtube style tab bar under the nav bar on the main page - white selector bar with dropshadow under it display which tab is selected - title on the left hand side of the nav bar provide a label
