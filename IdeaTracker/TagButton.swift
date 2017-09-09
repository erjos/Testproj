import UIKit

class TagButton: UIButton {
    // need to set the delegate for the button
    weak var tagButtonDelegate: TagButtonDelegate?
    
    var selectedColor = UIColor(red: 193/255, green: 169/255, blue: 124/255, alpha: 255/255)
    
    //nice light brown: 193 169 124
    
    //dark brown: status bar current: 119 83 50
    var defaultColor = UIColor(red: 119/255, green: 83/255, blue: 50/255, alpha: 255/255)
    
    //TODO: could use something like this to identify if the title of the tag should be saved to the DB
    var isTagActive: Bool?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //self.roundCorners()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //This init is called when you add via the storyboard.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.showsTouchWhenHighlighted = true
        
        //might not be the best way to do this, could be fucking up the callbacks
        self.addTarget(self, action: #selector(self.handleTap), for: .touchDown)
    }
    
    func handleTap(){
        if(self.titleLabel?.text == "+"){
            //Delegate callback method
            tagButtonDelegate?.didSelectAddTag(tagButton: self)
        } else {
            let isSelected = (backgroundColor == selectedColor)
            backgroundColor = isSelected ? defaultColor : selectedColor
            isTagActive = !isSelected
            tagButtonDelegate?.didSelectTag()
        }
    }
}

protocol TagButtonDelegate: class{
    func didSelectAddTag(tagButton: TagButton)
    func didSelectTag()
}

extension UIView{
    
    //Rounds UIView corners with a cornerRadius of 10.0
    func roundCorners(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.0
    }
}
