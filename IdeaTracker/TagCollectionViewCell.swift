import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    var selectedColor = UIColor(red: 193/255, green: 169/255, blue: 124/255, alpha: 255/255)
    var defaultColor = UIColor(red: 119/255, green: 83/255, blue: 50/255, alpha: 255/255)
    
    var isTagActive: Bool = false
    
    weak var tagCellDelegate: TagCellDelegate?
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    
    func updateTagState(){
        if(self.cellLabel?.text == "+"){
            tagCellDelegate?.didSelectAddTag(tagCell: self)
        } else {
            let isSelected = (background.backgroundColor == selectedColor)
            background.backgroundColor = isSelected ? defaultColor : selectedColor
            isTagActive = !isSelected
        }
    }
    
    func addButtonTapped(){
        tagCellDelegate?.didSelectAddTag(tagCell: self)
    }
}

protocol TagCellDelegate: class{
    func didSelectAddTag(tagCell: TagCollectionViewCell)
}

extension UIView{
    
    //Rounds UIView corners with a cornerRadius of 10.0
    func roundCorners(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.0
    }
}
