
import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var passedRepository: Repository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        self.navigationController?.navigationBar.isHidden = false;
        self.navigationItem.title = passedRepository.repositoryName
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell") as! DetailTableViewCell
            cell.isUserInteractionEnabled = false
            switch indexPath.row {
            case 0:
                cell.configureCell(text: "Description: " + passedRepository.description!)
            case 1:
                cell.configureCell(text: "Language: " + passedRepository.language!)
            case 2:
                cell.configureCell(text: "URL: " + passedRepository.repositoryLink!)
                cell.isUserInteractionEnabled = true
            case 3:
                cell.configureCell(text: "Forks: " + String(passedRepository.forkNumber))
            case 4:
                cell.configureCell(text: "Stars: " + String(passedRepository.starsNumber))
            case 5:
                cell.configureCell(text: "Created at: " + passedRepository.createdAt)
            case 6:
                cell.configureCell(text: "Updated at: " + passedRepository.updatedAt)
            default:
                break
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        cell.configureCell(authorImageURL: passedRepository.authorImageUrl!,
                           repositoryName: passedRepository.authorName!,
                           authorName: passedRepository.authorName!,
                           forkNumber: "",
                           issueNumber: "",
                           urlLink: passedRepository.ownerLink!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "OWNER"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            tableView.estimatedRowHeight = 40
            return UITableViewAutomaticDimension
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            UIApplication.shared.open(URL(string: passedRepository.repositoryLink!)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: passedRepository.ownerLink!)!, options: [:], completionHandler: nil)
        }
    }
}
