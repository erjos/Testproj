import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var dismiss: UIImageView!
    @IBOutlet weak var entryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}