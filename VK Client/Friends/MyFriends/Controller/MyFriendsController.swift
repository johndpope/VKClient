//
//  MyFriendsController.swift
//  VK Client
//
//  Created by Eugene Kiselev on 02.08.2020.
//  Copyright © 2020 Eugene Kiselev. All rights reserved.
//

import UIKit
import RealmSwift

class MyFriendsController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    let realmManager = RealmManager()
    var friends = [User]()
    var friendsSection = [String]()
    lazy var friendsDictionary = [String: [User]]()
    var filteredUsers = [User]()
    var searchBarIsEmpty: Bool {
        
        guard let text = searchController.searchBar.text else { return false }
        
        return text.isEmpty
    }
    var isFiltering: Bool {
        
        return searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRequestFriends()
        setupSearchController()
        tableView.sectionIndexColor = .white
    }
    
    // MARK: - Help Function
    
    private func fetchRequestFriends() {
        
        do {
            let realm = try Realm()
            
            let friend = realm.objects(User.self)
            
            friends = Array(friend)
        } catch {
            
            print(error)
        }
        
        sortFriend()
    }
    
    private func sortFriend() {

        for friend in friends {

            guard let name = friend.returnFullName() else { return }
            let key = "\(name[name.startIndex])"

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
        
        if isFiltering {
            return 1
        }

        return friendsSection.count
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isFiltering {
            return filteredUsers.count
        }

        let friendKey = friendsSection[section]

        if let friend = friendsDictionary[friendKey] {
            return friend.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell
        
        if isFiltering {

            cell.configure(for: filteredUsers[indexPath.row])
        } else {

            let friendKey = friendsSection[indexPath.section]

            if var friendValue = friendsDictionary[friendKey.uppercased()] {

                if isFiltering {
                    friendValue = filteredUsers
                }

                cell.selectionStyle = .none
                cell.configure(for: friendValue[indexPath.row])
            }
        }
        
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsSection
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if isFiltering {
            return ""
        }

        return friendsSection[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        
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
                
                if isFiltering {

                    let friends = filteredUsers[indexPath.row]

                    detailFriendController?.fetchRequestPhotosUser(for: friends.id)
                    detailFriendController?.titleItem = friends.returnFullName()
                    detailFriendController?.ownerID = friends.id
                } else {
                    
                    let friendKey = friendsSection[indexPath.section]
                    
                    if let friendValue = friendsDictionary[friendKey.uppercased()] {

                        let friendsValue = friendValue[indexPath.row]

                        detailFriendController?.fetchRequestPhotosUser(for: friendsValue.id)
                        detailFriendController?.titleItem = friendsValue.returnFullName()
                        detailFriendController?.ownerID = friendsValue.id
                    }
                }
            }
        }
    }
}
