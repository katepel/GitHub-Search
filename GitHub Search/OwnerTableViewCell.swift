
import UIKit

class OwnerTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ownerImage.layer.cornerRadius = (self.ownerImage.frame.width / 2)
        ownerImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(text: String) {
//        self..text = text
    }
}
