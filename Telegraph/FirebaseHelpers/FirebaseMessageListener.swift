//
//  FirebaseMessageListener.swift
//  Telegraph
//
//  Created by Soro on 2022-11-28.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseMessageListener {
    static let shared = FirebaseMessageListener()
    
    private init(){}
    
    //MARK: ADD UPDATE DELETE
    func addMessage(_ message: LocalMessage, memberId: String){
        do{
            let _ = try FirebaseRefrence(.Messages).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        } catch {
            print("error saving message. ",error.localizedDescription)
        }
    }
    
}
