
import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var issuesNumberLabel: UILabel!
    @IBOutlet weak var forksNumberLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        authorImage.layer.cornerRadius = (self.authorImage.frame.width / 2)
        authorImage.layer.masksToBounds = true
        repositoryNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func configureCell(authorImageURL: String, repositoryName: String, authorName: String, forkNumber: String, issueNumber: String, urlLink: String) {
        setImage(imageView: authorImage, imageUrl: authorImageURL)
        self.repositoryNameLabel.text = repositoryName
        self.authorNameLabel.text = authorName
        if urlLink == "" {
            self.linkLabel.text = ""
            self.forksNumberLabel.text = "" + forkNumber + " FORKS"
            self.issuesNumberLabel.text = issueNumber + " ISSUES"
        } else {
            self.forksNumberLabel.text = ""
            self.issuesNumberLabel.text = ""
            self.linkLabel.text = urlLink
        }
    }
    
    func setImage(imageView: UIImageView, imageUrl: String) {
        let url = URL(string: imageUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error!")
            } else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data!)
                }
            }
        }
        task.resume()
    }
}


