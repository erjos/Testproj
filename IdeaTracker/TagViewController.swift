import UIKit
import RealmSwift

class TagViewController: UIViewController {
    
    //Maybe I can use this on the editor vc to mavoid repeating all this code
    
    fileprivate let TAG_COLLECTION_CELL_XIB = "TagCollectionViewCell"
    fileprivate let STORYBOARD_MAIN = "Main"
    fileprivate let reuseIdentifier = "TagCell"
    fileprivate let ID_TAG_EDITOR_VC = "tagEditor"
    
    var defaultTags: Results<Tag>?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        defaultTags = realm.objects(Tag.self)
        self.collectionView.register(UINib(nibName: TAG_COLLECTION_CELL_XIB, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    //repeated code from Editor VC
    @objc func handleLongPress(_ sender: UIGestureRecognizer){
        let cell = sender.view as! TagCollectionViewCell
        let tagEditorVC = UIStoryboard.init(name: STORYBOARD_MAIN, bundle: nil).instantiateViewController(withIdentifier: ID_TAG_EDITOR_VC) as? TagEditorViewController
        //tagEditorVC?.tagName = cell.button.titleLabel?.text
        let tagName = cell.cellLabel.text
        let tag = defaultTags?.filter("name == %@", tagName!).first
        tagEditorVC?.selectedTag = tag
        tagEditorVC?.isDeleteHidden = false
        self.navigationController?.present(tagEditorVC!, animated: true, completion:nil)
    }
}

extension TagViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultTags!.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! TagCollectionViewCell
        
        //Repeated code from Editor VC is there a way to cut down on this
        var title: String
        if (indexPath.row == defaultTags?.count){
            cell.tagCellDelegate = self
            title = "+"
        } else {
            //Gesture Config
            let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
            pressGesture.cancelsTouchesInView = false
            //play with duration to get the right time
            pressGesture.minimumPressDuration = 0.7
            pressGesture.delaysTouchesBegan = true
            cell.addGestureRecognizer(pressGesture)
            title = (defaultTags?[indexPath.row].name)!
        }
        cell.cellLabel.text = title
        
        return cell
    }
}

extension TagViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! TagCollectionViewCell
        item.handleTap()
    }
}

extension TagViewController: TagCellDelegate{
    func didSelectAddTag(tagCell: TagCollectionViewCell) {
        let tagEditorVC = UIStoryboard.init(name: STORYBOARD_MAIN, bundle: nil).instantiateViewController(withIdentifier: ID_TAG_EDITOR_VC)
        self.present(tagEditorVC, animated: true, completion: nil)
    }
}
