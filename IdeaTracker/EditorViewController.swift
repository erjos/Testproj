import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var notesTextView: UITextView!
    
    fileprivate let reuseIdentifier = "TagCell"
    
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

extension EditorViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath)
        cell.backgroundColor = UIColor.black
        // Configure the cell
        return cell
    }
}
