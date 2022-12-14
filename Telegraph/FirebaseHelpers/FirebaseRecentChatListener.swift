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
            
            recentChats.sort(by: { $0.date! > $1.date! })
            completion(recentChats)
        }
    }
    
    func resetRecentCounter(chatRoomId: String) {
        FirebaseRefrence(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).whereField(kSENDERID, isEqualTo: User.currentId).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else{
                print("no documents for recent")
                return
            }
            let allRecent = documents.compactMap { (queryDocumentSnapshot) -> RecentChat? in
                return try? queryDocumentSnapshot.data(as: RecentChat.self)
            }
            if allRecent.count > 0 {
                self.clearUnreadCounter(recent: allRecent.first!)
            }
        }
    }
    
    func clearUnreadCounter(recent: RecentChat){
        var newRecent = recent
        newRecent.unreadCounter = 0
        self.saveRecent(recent)
    }
    
    func saveRecent(_ recent: RecentChat) {
        do{
            try FirebaseRefrence(.Recent).document(recent.id).setData(from: recent)
        }catch{
            print("Error saving recent chat ",error.localizedDescription)
        }
    }
    
    func deleteRecent(_ recent: RecentChat) {
        FirebaseRefrence(.Recent).document(recent.id).delete()
    }
    
    
    
}
