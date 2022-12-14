//
//  EditProfileTableViewController.swift
//  Telegraph
//
//  Created by Soro on 2022-11-13.
//

import UIKit
import Gallery
import ProgressHUD
class EditProfileTableViewController: UITableViewController {
    
    //MARK: IBOUTLETS
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    //MARK: VARS
    var gallary: GalleryController!
    
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
        
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "EditToStatusSegue", sender: self)
        }
        
    }
    
    //MARK: IBACTIONS
    
    @IBAction func editButtonPressed(_ sender: Any) {
        showImageGallery()
    }
    
    //MARK: UPDATE UI
    private func showUserInfo(){
        if let user = User.currentUser {
            usernameTextField.text = user.username
            statusLabel.text = user.status
            
            if user.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user.avatarLink) { image in
                    self.avatarImageView.image = image?.circleMasked
                }
            }
             
        }
    }

    //MARK: CONFIGURE
    private func configureTextField(){
        usernameTextField.delegate = self
        usernameTextField.clearButtonMode = .whileEditing
    }
    
    //MARK: GALLERY
    private func showImageGallery(){
        self.gallary = GalleryController()
        self.gallary.delegate = self
        
        Config.tabsToShow = [.cameraTab, .imageTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        self.present(gallary,animated: true, completion: nil)
    }
    
    //MARK: UPLOAD IMAGES
    private func uploadAvatarImage(_ image : UIImage){
        let fileDirectory = "Avatars/_\(User.currentId).jpg"
        FileStorage.uploadImage(image, directory: fileDirectory) { documentLink in
            if var user = User.currentUser {
                user.avatarLink = documentLink ?? ""
                saveUserLocally(user)
                FirebaseUserListener.shared.saveUserToFirestore(user)
            }
            
//            FileStorage.saveFileLocally(fileData: image.jpegData(compressionQuality: 1.0)! as NSData, fileName: User.currentId)
        }
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

extension EditProfileTableViewController: GalleryControllerDelegate {
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        if images.count > 0 {
            images.first!.resolve { avatar in
                
                if avatar != nil {
                    self.uploadAvatarImage(avatar!)
                    self.avatarImageView.image = avatar?.circleMasked
                }else{
                    ProgressHUD.showFailed("Couldn't select image.")
                }
            }
        }
        controller.dismiss(animated: true,completion: nil)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        controller.dismiss(animated: true,completion: nil)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true,completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true,completion: nil)
    }
    
    
}
