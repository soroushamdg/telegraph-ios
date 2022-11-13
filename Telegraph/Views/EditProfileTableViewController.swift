//
//  EditProfileTableViewController.swift
//  Telegraph
//
//  Created by Soro on 2022-11-13.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    
    //MARK: IBOUTLETS
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK: VIEW LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        configureTextField()
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
        return section == 0 ? 0.0 : 30.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
   
    //MARK: UPDATE UI
    private func showUserInfo(){
        if let user = User.currentUser {
            usernameTextField.text = user.username
            statusLabel.text = user.status
            
            if user.avatarLink != "" {}
             
        }
    }

    //MARK: CONFIGURE
    private func configureTextField(){
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }
}


extension EditProfileTableViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            if textField.text != "" {
                if var user = User.currentUser {
                    user.username = textField.text!
                    saveUserLocally(user)
                    FirebaseUserListener.shared.saveUserToFirestore(user)
                }
            }
            textField.resignFirstResponder() //dismiss keyboard
            
            return false
        }
        
        return true
    }
}
