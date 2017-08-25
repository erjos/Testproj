import UIKit

class TagButton: UIButton {
    
    //need to change the button color to this when it is selected...
    var selectedColor = UIColor(red: 189/255, green: 192/255, blue: 255/255, alpha: 255/255)
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //This init is called when you add via the storyboard...
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.showsTouchWhenHighlighted = true
        
        //want this action triggered for all buttons of this type
        self.addTarget(self, action: #selector(self.highlightButton), for: .allTouchEvents)
    }
    
    func highlightButton(){
        //code
    }
    
    //Add selected and deselected characteristics
    //DESELECT: 7374FF
    //SELECT: BDC0FF
}
