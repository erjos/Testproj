import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    var selectedColor = UIColor(red: 193/255, green: 169/255, blue: 124/255, alpha: 255/255)
    var defaultColor = UIColor(red: 119/255, green: 83/255, blue: 50/255, alpha: 255/255)
    
    var isTagActive: Bool?
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    
    func handleTap(){
        if(self.cellLabel?.text == "+"){
            //Delegate callback method
            //tagButtonDelegate?.didSelectAddTag(tagButton: self)
        } else {
            let isSelected = (background.backgroundColor == selectedColor)
            background.backgroundColor = isSelected ? defaultColor : selectedColor
            isTagActive = !isSelected
        }
    }
}
