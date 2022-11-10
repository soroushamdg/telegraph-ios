//
//  SettingsTableViewController.swift
//  Telegraph
//
//  Created by Soro on 2022-11-04.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    //MARK: IBOUTLETS

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var appversionLabel: UILabel!
    //MARK: IBACTIONS
   
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {

    }
    
    @IBAction func termAndConditionsButtonPressed(_ sender: Any) {
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
    }
    
    //MARK: LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showUserInfo()
    }
    
    //MARK: TABLEVIEW DELEGATE
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    
    //MARK: UPDATE UI
    private func showUserInfo(){
        if let user = User.currentUser {
            usernameLabel.text = user.username
            statusLabel.text = user.status
            appversionLabel.text = "App version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            if user.avatarLink != "" {}
        }
    }
}
