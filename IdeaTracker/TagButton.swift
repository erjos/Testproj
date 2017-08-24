import UIKit

class TagButton: UIButton {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.0
    }
    
    
    //Add selected and deselected characteristics
    //DESELECT: 7374FF
    //SELECT: BDC0FF
}
