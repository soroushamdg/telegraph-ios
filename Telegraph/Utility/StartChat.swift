//
//  StartChat.swift
//  Telegraph
//
//  Created by Soro on 2022-11-18.
//

import Foundation
import Firebase
//MARK: START CHAT
func startChat(user1: User, user2: User) -> String {
    let chatRoomId = chatroomIdFrom(user1id: user1.id, user2id: user2.id)
    
    // we need to create recent object for both users.
    createRecentItems(chatRoomId: chatRoomId, users: [user1,user2])
    return chatRoomId
}

func createRecentItems(chatRoomId: String, users: [User]){
    var memberIdsToCreateRecent = [users.first!.id,users.last!.id]
    
    FirebaseRefrence(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { snapshot, error in
        guard let snapshot = snapshot else {
            return
        }
        if !snapshot.isEmpty {
            memberIdsToCreateRecent = removeMemberWhoHasRecent(snapshot: snapshot, memberIds: memberIdsToCreateRecent)
        }
        for userId in memberIdsToCreateRecent {
            let senderUser = userId == User.currentId ? User.currentUser! : getReceiverFrom(users: users)
            let receiverUser = userId == User.currentId ? getReceiverFrom(users: users) : User.currentUser!
            let recentObject = RecentChat(id: UUID().uuidString,chatRoomID: chatRoomId,senderId: senderUser.id,senderName: senderUser.username,receiverId: receiverUser.id,receiverName: receiverUser.username,date: Date(), memberIds: [senderUser.id,receiverUser.id],lastMessage: "",unreadCounter: 0,avatarLink: receiverUser.avatarLink)
            FirebaseRecentListener.shared.saveRecent(recentObject )
        }
    }
}

func removeMemberWhoHasRecent(snapshot: QuerySnapshot, memberIds: [String]) -> [String]{
    var memberIdsToCreateRecent = memberIds
    for recentData in snapshot.documents {
        let currentRecent = recentData.data() as Dictionary
        if let currentUserId = currentRecent[kSENDERID] {
            if memberIdsToCreateRecent.contains(currentUserId as! String) {
                if let index = memberIdsToCreateRecent.firstIndex(of: currentUserId as! String){
                    memberIdsToCreateRecent.remove(at: index)
                }
            }
        }
    }
    return memberIdsToCreateRecent
}

func chatroomIdFrom(user1id: String, user2id: String) -> String {
    var chatroomid = ""
    let value = user1id.compare(user2id).rawValue
    chatroomid = value < 0 ? (user1id + user2id) : (user2id + user1id)
    return chatroomid
}

func getReceiverFrom(users: [User]) -> User{
    var allUsers = users
    allUsers.remove(at: allUsers.firstIndex(of: User.currentUser!)!)
    return allUsers.first!
}
