import UIKit

class TagButton: UIButton {
    
    //need to change the button color to this when it is selected...
    
    
    var selectedColor = UIColor(red: 193/255, green: 169/255, blue: 124/255, alpha: 255/255)
    
    //nice light brown: 193 169 124
    
    //dark brown: status bar current: 119 83 50
    var defaultColor = UIColor(red: 119/255, green: 83/255, blue: 50/255, alpha: 200/255)
    
//    var selectedColor = UIColor(red: 189/255, green: 192/255, blue: 255/255, alpha: 255/255)
//    var defaultColor = UIColor(red: 115/255, green: 116/255, blue: 255/255, alpha: 255/255)
    
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
        
        //want this action triggered for all buttons of this type
        self.addTarget(self, action: #selector(self.highlightButton), for: .touchDown)
    }
    
    func highlightButton(){
        let isSelected = (backgroundColor == selectedColor)
        backgroundColor = isSelected ? defaultColor : selectedColor
    }
}

extension UIView{
    
    //Rounds UIView corners with a cornerRadius of 10.0
    func roundCorners(){
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.0
    }
}
