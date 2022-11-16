//
//  UserTableViewCell.swift
//  Telegraph
//
//  Created by Soro on 2022-11-16.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    //MARK: IBOUTLETS
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(user: User) {
        usernameLabel.text = user.username
        statusLabel.text = user.status
        setAvatar(avatarLink: user.avatarLink)
    }
    
    private func setAvatar(avatarLink: String){
        if avatarLink != "" {
            FileStorage.downloadImage(imageUrl: avatarLink) { image in
                self.avatarImageView.image = image
            }
        }else{
            self.avatarImageView.image = UIImage(named: "avatar")?.circleMasked
        }
    }

}
