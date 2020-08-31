//
//  MyFriendsController.swift
//  VK Client
//
//  Created by Eugene Kiselev on 02.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit

class MyFriendsController: UITableViewController {
    
    var friends = [User(nameSurnameFriend: "Иванов Иван", imageFriend: "Иван Иванов"),
                   User(nameSurnameFriend: "Сергиев Сергей", imageFriend: "Сергей Сергиев"),
                   User(nameSurnameFriend: "Дмитров Дмитрий", imageFriend: "Дмитрий Дмитров"),
                   User(nameSurnameFriend: "Лукашенко Александр", imageFriend: "Александр Лукашенко"),
                   User(nameSurnameFriend: "Путин Владимир", imageFriend: "Владимир Путин"),
                   User(nameSurnameFriend: "Иванов Евгений", imageFriend: "Евгений Иванов"),
                   User(nameSurnameFriend: "Рыбов Никита", imageFriend: "Никита Рыбов"),
                   User(nameSurnameFriend: "Олегов Олег", imageFriend: "Олег Олегов"),
                   User(nameSurnameFriend: "Эдуардов Эдуард", imageFriend: "Эдуард Эдуардов"),
                   User(nameSurnameFriend: "Гагарин Юрий", imageFriend: "Юрий Гагарин"),
                   User(nameSurnameFriend: "Янов Ян", imageFriend: "Ян Янов"),
                   User(nameSurnameFriend: "Алексеев Алексей", imageFriend: "Алексей Алексеев")]
    var friendsSection = [String]()
    var friendsDictionary = [String: [User]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionIndexColor = .white
        sortFriend()
    }
    
    // MARK: - Help Function
    
    private func sortFriend() {
        
        for friend in friends {
            
            let key = "\(friend.nameSurnameFriend[friend.nameSurnameFriend.startIndex])"
            
            if var friendValue = friendsDictionary[key] {
                friendValue.append(friend)
                friendsDictionary[key] = friendValue
            } else {
                friendsDictionary[key] = [friend]
            }
            
            friendsSection = [String](friendsDictionary.keys).sorted()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsSection.count
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let friendKey = friendsSection[section]
        
        if let friend = friendsDictionary[friendKey] {
            return friend.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell
        
        let friendKey = friendsSection[indexPath.section]
        
        if let friendValue = friendsDictionary[friendKey.uppercased()] {
            
// Отмена выделения ячейки при выборе:
            cell.selectionStyle = .none
            cell.configure(for: friendValue[indexPath.row])
        }
        
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsSection
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsSection[section].uppercased()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
// Прозрачность header:
        header.alpha = 0.3
        header.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        header.textLabel?.textAlignment = .left
        header.textLabel?.textColor = .white
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addImage" {
            
            let detailFriendController = segue.destination as? DetailFriendController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let friendKey = friendsSection[indexPath.section]
                
                if let friendValue = friendsDictionary[friendKey.uppercased()] {
                    
                    let image = friendValue[indexPath.row]
                    let name = friendValue[indexPath.row]
                    
                    detailFriendController?.titleItem = name.nameSurnameFriend
                    detailFriendController?.friendsImage.removeAll()
                    detailFriendController?.friendsImage.append(image)
                }
            }
        }
    }
}
