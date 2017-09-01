
import UIKit
import Alamofire

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var repositories: [Repository]?
    var searchURL = "https://api.github.com/repositories?access_token=a43578b91a298207ccd76c80541ed48249bd31c6"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchTableViewCell")
        tableView.separatorStyle = .none
 
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.isHidden = true;
        
        getData(url: searchURL)
    }
    
    func getData(url: String) {
        Alamofire.request(url).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let myJson = responseData.result.value! as! [AnyObject]
                
                self.repositories = [Repository]()
                
                for resultElement in myJson {
                    let newRepository = Repository()
                    newRepository.idRepository = resultElement["id"] as? Int
                    newRepository.repositoryName = resultElement["name"] as? String
                    newRepository.repositoryLink = resultElement["html_url"] as? String
                    newRepository.authorName = (resultElement["owner"] as AnyObject)["login"] as? String
                    newRepository.authorImageUrl = (resultElement["owner"] as AnyObject)["avatar_url"] as? String
                    newRepository.ownerLink = (resultElement["owner"] as AnyObject)["url"] as? String
                    newRepository.description = resultElement["description"] as? String
                    
                    Alamofire.request("https://api.github.com/repos/" + newRepository.authorName! + "/" + newRepository.repositoryName! + "?access_token=a43578b91a298207ccd76c80541ed48249bd31c6").responseJSON { (responseData) -> Void in
                        if((responseData.result.value) != nil) {
                            let myNewJson = responseData.result.value! as AnyObject
                            
                            newRepository.createdAt = ((myNewJson["created_at"] as? String)?.replacingOccurrences(of: "T", with: " "))!
                            newRepository.updatedAt = ((myNewJson["updated_at"] as? String)?.replacingOccurrences(of: "T", with: " "))!
                            newRepository.language = myNewJson["language"] as? String
                            newRepository.forkNumber = (myNewJson["forks"] as? Int)!
                            newRepository.issueNumber = (myNewJson["open_issues"] as? Int)!
                            newRepository.starsNumber = (myNewJson["stargazers_count"] as? Int)!
                            
                            self.repositories?.append(newRepository)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    @IBAction func displayActionSheet(_ sender: Any) {
        let alertController = UIAlertController(title: "Sort", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Forks", style: .default, handler: self.sortTable))
        alertController.addAction(UIAlertAction(title: "Stars", style: .default, handler: self.sortTable))
        alertController.addAction(UIAlertAction(title: "Updated", style: .default, handler: self.sortTable))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sortTable(alert: UIAlertAction) {
        if alert.title == "Forks" {
            getData(url: searchURL + "&sort=forks&order=desc")
        }
        if alert.title == "Stars" {
            getData(url: searchURL + "&sort=stars&order=desc")
        }
        if alert.title == "Updated" {
            getData(url: searchURL + "&sort=updated&order=desc")
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var keywords = searchBar.text
        keywords = keywords?.replacingOccurrences(of: " ", with: "+")
        print(searchURL + "&q=\(keywords!)")
        getData(url: searchURL + "&q=\(keywords!)")
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as! SearchTableViewCell
        var fork = ""
        var issue = ""

        if let forkNum = self.repositories?[indexPath.row].forkNumber {
            fork = String(forkNum)
        }
        if let issueNum = self.repositories?[indexPath.row].issueNumber {
            issue = String(issueNum)
        }
        cell.configureCell(authorImageURL: (self.repositories?[indexPath.row].authorImageUrl!)!,
                           repositoryName: (self.repositories?[indexPath.row].repositoryName!)!,
                           authorName: (self.repositories?[indexPath.row].authorName!)!,
                           forkNumber: fork,
                           issueNumber: issue,
                           urlLink: "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        viewController.passedRepository = self.repositories?[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
}
