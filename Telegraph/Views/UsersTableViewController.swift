//
//  UsersTableViewController.swift
//  Telegraph
//
//  Created by Soro on 2022-11-16.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    //MARK: VARIABLE
    var allUsers: [User] = []
    var filteredUsers: [User] = []

    let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createDummyUsers()
        downloadUsers()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return searchController.isActive ? filteredUsers.count : allUsers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell

        let user = searchController.isActive ? filteredUsers[indexPath.row] : allUsers[indexPath.row]
        cell.configure(user: user)
        return cell
    }
    
    //MARK: DOWNLOAD USERS
    private func downloadUsers(){
        FirebaseUserListener.shared.downloadAllUsersFromFirebase { allFirebaseUsers in
            
            self.allUsers = allFirebaseUsers
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    


}
