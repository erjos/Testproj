import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notesTextView: UITextView!
    
    fileprivate let reuseIdentifier = "TagCell"
    
    let defaultTags = ["Book", "Movie", "Quote", "Idea", "5", "6", "7", "8", "9", "10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleNotesView()
        self.collectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func styleNotesView(){
        notesTextView.clipsToBounds = true
        notesTextView.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EditorViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TagCollectionViewCell
        
        let title = defaultTags[indexPath.row]
        cell.button.setTitle(title, for: .normal)
        cell.backgroundColor = UIColor.clear
        cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width: 60, height: 30)
        // Configure the cell
        
        //TODO: Ideal height for tag cells is 30 x 60
        return cell
    }
}
