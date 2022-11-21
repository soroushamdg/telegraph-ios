//
//  RecentChatListener.swift
//  Telegraph
//
//  Created by Soro on 2022-11-18.
//

import Foundation
import Firebase

class FirebaseRecentListener {
    static let shared = FirebaseRecentListener()
    
    private init() {}
    
    func downloadRecentChatsFromFirestore(completion : @escaping (_ allRecents:[RecentChat]) -> Void){
        FirebaseRefrence(.Recent).whereField(kSENDERID, isEqualTo: User.currentId).addSnapshotListener {snapshot, error in
            var recentChats: [RecentChat] = []
            guard let documents = snapshot?.documents else {
                print("no documents for recent chats")
                return
            }
            
            let allRecents = documents.compactMap { (queryDocumentSnapshot) -> RecentChat? in
                return try? queryDocumentSnapshot.data(as: RecentChat.self)
            }
            
            for recent in allRecents {
                if recent.lastMessage != "" {
                    recentChats.append(recent)
                }
            }
            
            recentChats.sorted { $0.date! > $1.date! }
            completion(recentChats)
        }
    }
    
    func addRecent(_ recent: RecentChat) {
        do{
            try FirebaseRefrence(.Recent).document(recent.id).setData(from: recent)
        }catch{
            print("Error saving recent chat ",error.localizedDescription)
        }
    }
    
}
