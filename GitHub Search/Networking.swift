
import Foundation
import Alamofire

class Networking {
    
    var repositories: [Repository] = []
    
    func getData(url: String) {
        Alamofire.request(url).responseJSON (completionHandler: {
            responseData in
            self.parseData(jsonData: responseData.data!)
        })
    }
    
    func parseData(jsonData: Data) {
        do {
                let myJson = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [AnyObject]
                
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
                    
                    Alamofire.request("https://api.github.com/repos/" + newRepository.authorName! + "/" + newRepository.repositoryName!).responseJSON { (responseData) -> Void in
                        if((responseData.result.value) != nil) {
                            let myNewJson = responseData.result.value! as AnyObject
                            
                            newRepository.createdAt = ((myNewJson["created_at"] as? String)?.replacingOccurrences(of: "T", with: " "))!
                            newRepository.updatedAt = ((myNewJson["updated_at"] as? String)?.replacingOccurrences(of: "T", with: " "))!
                            newRepository.language = myNewJson["language"] as? String
                            newRepository.forkNumber = (myNewJson["forks"] as? Int)!
                            newRepository.issueNumber = (myNewJson["open_issues"] as? Int)!
                            newRepository.starsNumber = (myNewJson["stargazers_count"] as? Int)!
                        }
                    }
                    
                    self.repositories.append(newRepository)
                }
        } catch {
             print(error)
        }
    }

//    func getData(url: String) {
//        Alamofire.request(url).responseJSON { (responseData) -> Void in
//            if((responseData.result.value) != nil) {
//                let myJson = responseData.result.value! as! [AnyObject]
//                
//                self.repositories = [Repository]()
//                
//                for resultElement in myJson {
//                    let newRepository = Repository()
//                    newRepository.idRepository = resultElement["id"] as? Int
//                    newRepository.repositoryName = resultElement["name"] as? String
//                    newRepository.repositoryLink = resultElement["html_url"] as? String
//                    newRepository.authorName = (resultElement["owner"] as AnyObject)["login"] as? String
//                    newRepository.authorImageUrl = (resultElement["owner"] as AnyObject)["avatar_url"] as? String
//                    newRepository.ownerLink = (resultElement["owner"] as AnyObject)["url"] as? String
//                    newRepository.description = resultElement["description"] as? String
//                    
//                    Alamofire.request("https://api.github.com/repos/" + newRepository.authorName! + "/" + newRepository.repositoryName!).responseJSON { (responseData) -> Void in
//                        if((responseData.result.value) != nil) {
//                            let myNewJson = responseData.result.value! as AnyObject
//                            
//                            newRepository.createdAt = ((myNewJson["created_at"] as? String)?.replacingOccurrences(of: "T", with: " "))!
//                            newRepository.updatedAt = ((myNewJson["updated_at"] as? String)?.replacingOccurrences(of: "T", with: " "))!
//                            newRepository.language = myNewJson["language"] as? String
//                            newRepository.forkNumber = (myNewJson["forks"] as? Int)!
//                            newRepository.issueNumber = (myNewJson["open_issues"] as? Int)!
//                            newRepository.starsNumber = (myNewJson["stargazers_count"] as? Int)!
//                        }
//                    }
//                    
//                    self.repositories.append(newRepository)
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
    
}
