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
    func loginUserWithEmail(email: String, password: String, completion: @escaping (_ error:Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            
            if error == nil && authDataResult!.user.isEmailVerified {
                FirebaseUserListener.shared.downloadUserFromFirebase(userId: authDataResult!.user.uid,email: email)
                completion(nil ,true)
            }else{
                print("email is not verified")
                completion(error!, false)
            }
        }
    }
    
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
                    saveUserLocally(user)
                    self.saveUserToFirestore(user)
                }
            }
        }
    }
    
    // MARK: SEND LINK EMAIL
    func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void){
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    
    func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    func logoutCurrentUser(completion: @escaping (_ error: Error?) -> Void){
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)
        }     catch{
            completion(error)
        }
    }
    
    // MARK: SAVE USERS
    func saveUserToFirestore(_ user: User){
        do {
            try FirebaseRefrence(.User).document(user.id).setData(from: user)
        }catch{
            print(error.localizedDescription, "adding user")
        }
    }
    
    // MARK: DOWNLOAD USER FROM FIREBASE
    func downloadUserFromFirebase(userId: String, email: String? = nil) {
        FirebaseRefrence(.User).document(userId).getDocument { querySnapshot, error in
            guard let document = querySnapshot else {
                print("no document for user")
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("error decoding user", error)
            }
        }
    }
}

