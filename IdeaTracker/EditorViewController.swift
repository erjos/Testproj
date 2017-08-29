import UIKit

class EditorViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notesTextView: UITextView!
    
    fileprivate let reuseIdentifier = "TagCell"
    
    let defaultTags = ["Book", "Movie", "Quote", "Idea", "Technology", "Product", "Marketing", "Work", "Random", "Fun"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
        self.collectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "Pencil")
        imageView.image = logo
        self.navigationItem.titleView = imageView
    }
    
    private func setupStyle(){
        
        //TODO: fix round corners so it can take any number of views from 1 ...
        //notesTextView.roundCorners()
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

extension EditorViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var standardTagWidth: CGFloat = 30
        let standardTagHeight: CGFloat = 30
        
        let tagLength = CGFloat(defaultTags[indexPath.row].characters.count)
        if(tagLength > 3){
            let diff:CGFloat = tagLength - 3
            let space:CGFloat = diff * 10
            standardTagWidth = 30 + space
        }
        return CGSize(width: standardTagWidth, height: standardTagHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
}

extension EditorViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "Notes..."){
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""){
            textView.text = "Notes..."
            
            //TODO:Light gray color for placeholder text in the UITextView, still a little off from the text field color, but not too noticeable
            textView.textColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 255/255)
        }

    }
}
