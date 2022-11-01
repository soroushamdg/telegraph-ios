//
//  FirebaseUserListener.swift
//  Telegraph
//
//  Created by Soro on 2022-11-01.
//

import Foundation
import Firebase

class FirebaseUserListener {
    static let shared = FirebaseUserListener()
    
    private init () {}
    
    // MARK: LOGIN
    
    
    //MARK: REGISTER
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { AuthDataResult, error in
            completion(error)
            if error == nil{
                // send verification email
                AuthDataResult!.user.sendEmailVerification { error in
                    print("auth email sent with error:", error?.localizedDescription)
                }
                if AuthDataResult?.user != nil {
                    let user = User(id: AuthDataResult!.user.uid ,username: email, email: email, status: "Hey there, I'm using Telegraph!")
                    
                    
                }
            }
        }
        
       
    }
}
