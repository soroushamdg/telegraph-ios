//
//  ChatTableViewController.swift
//  Telegraph
//
//  Created by Soro on 2022-11-21.
//

import UIKit

class ChatTableViewController: UITableViewController {
    //MARK: VARS
    var allRecents:[RecentChat] = []
    var filteredRecents:[RecentChat] = []
    
    let searchController = UISearchController(searchResultsController: nil)

    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        downloadRecentChats()
        setupSearchController()
    }
    
    //MARK: IBACTION
    @IBAction func composeBarButtonPressed(_ sender: Any) {
        let userView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userView") as! UsersTableViewController
        
        navigationController?.pushViewController(userView, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return searchController.isActive ? filteredRecents.count : allRecents.count
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RecentChatTableViewCell
        let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
        cell.configure(recent: recent)
        return cell
    }
    
    //MARK: SETUP SEARCH CONTROLLER
    private func setupSearchController(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    private func filteredContentForSearchText(_ searchText: String){
        filteredRecents = allRecents.filter { recent in
            return recent.receiverName.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
    //MARK: TABLE VIEW DELEGATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle : UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)    {
        if editingStyle == .delete {
            let recent = searchController.isActive ? filteredRecents[indexPath.row] : allRecents[indexPath.row]
            FirebaseRecentListener.shared.deleteRecent(recent)
            searchController.isActive ? self.filteredRecents.remove(at: indexPath.row) : allRecents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    //MARK: Download Chats
    private func downloadRecentChats() {
        FirebaseRecentListener.shared.downloadRecentChatsFromFirestore { recents in
            self.allRecents = recents
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

}

extension ChatTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text!)
    }
}
