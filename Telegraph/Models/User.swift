//
//  User.swift
//  Telegraph
//
//  Created by Soro on 2022-11-01.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Equatable {
    var id: String
    var username: String
    var email: String
    var pushID = ""
    var avatarLink = ""
    var status: String
    
    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: kCURRENTUSER) {
               let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(User.self, from: dictionary)
                    return object
                } catch {
                    print("Error decoding user from user defaults.", error.localizedDescription)
                    
                }
            }
        }
        return nil
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}


func saveUserLocally(_ user: User){
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.setValue(data, forKey: kCURRENTUSER)
    }catch{
        print("error saving user locally.", error.localizedDescription)
    }
}

func createDummyUsers() {
    let names = ["Mamad","Hossein","Ali","Reza","Rahim","Sakine","Emma","Lamma"]
    
    var imageIndex = 1
    var userIndex = 1
    
    for i in 0..<names.count {
        let id = UUID().uuidString
        let fileDirectory = "Avatars/" + "_\(id)" + ".jpg"
        FileStorage.uploadImage(UIImage(named: "user\(imageIndex)")!, directory: fileDirectory) { documentLink in
            let user = User(id: id, username: names[i], email: "user\(userIndex)@mail.com", pushID: "", avatarLink: documentLink ?? "", status: "")
            userIndex += 1
            
            FirebaseUserListener.shared.saveUserToFirestore(user)
        }
        imageIndex += 1
        if imageIndex == names.count {
            imageIndex = 1
        }
    }
}
