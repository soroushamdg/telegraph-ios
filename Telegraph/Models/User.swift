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
    var id = ""
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

