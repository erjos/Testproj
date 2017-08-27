import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notesTextView: UITextView!
    
    fileprivate let reuseIdentifier = "TagCell"
    
    let defaultTags = ["Book", "Movie", "Quote", "Idea", "Technology", "Product", "Marketing", "Work", "Random", "Fun"]
    
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
        // Configure the cell
        return cell
    }
}

//fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 40.0, bottom: 10.0, right: 30.0)

extension EditorViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var standardTagWidth: CGFloat = 60
        let standardTagHeight: CGFloat = 30
        
        let tagLength = CGFloat(defaultTags[indexPath.row].characters.count)
        if(tagLength > 5){
            let diff:CGFloat = tagLength - 5
            let space:CGFloat = diff * 10
            standardTagWidth = 60 + space
        }
        //let itemsPerRow:CGFloat = 4
        //intended to Calculates all the padding that the row will contain
        //let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
        //let availableWidth = view.frame.width - paddingSpace
        //let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: standardTagWidth, height: standardTagHeight)
    }
    
    //TODO: because you can't set a maximum interItemSpacing with the control given, eventually we may want to subclass the flowLayout object and implement such a control, but for now I think reducing the minimum is ok.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
}
