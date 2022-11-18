//
//  ProfileTableViewController.swift
//  Telegraph
//
//  Created by Soro on 2022-11-16.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: VARIABLES
    var user: User?
    
    
    //MARK: LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        setupUI()
    }
    
    //MARK: TABLE VIEW DELEGATE
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "tableviewBackgroundColor")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {}
                
    }
    
    //MARK: SETUP UI
    private func setupUI(){
        if user != nil {
            self.title = user!.username
            usernameLabel.text = user!.username
            statusLabel.text = user!.status
            if user!.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user!.avatarLink) { image in
                    self.avatarImageView.image = image?.circleMasked
                }
            }
        }
    }
}
