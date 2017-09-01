
import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTextLabel: UILabel!
    
    func configureCell(text: String) {
        self.cellTextLabel.text = text
    }
}
