//
//  StartChat.swift
//  Telegraph
//
//  Created by Soro on 2022-11-18.
//

import Foundation

//MARK: START CHAT
func startChat(user1: User, user2: User) -> String {
    let chatRoomId = chatroomIdFrom(user1id: user1.id, user2id: user2.id)
    
    // we need to create recent object for both users.
    createRecentItems(chatRoomId: chatRoomId, users: [user1,user2])
    return chatRoomId
}

func createRecentItems(chatRoomId: String, users: [User]){
    FirebaseRefrence(.Recent).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { snapshot, error in
        
    }
}

func chatroomIdFrom(user1id: String, user2id: String) -> String {
    var chatroomid = ""
    let value = user1id.compare(user2id).rawValue
    chatroomid = value < 0 ? (user1id + user2id) : (user2id + user1id)
    return chatroomid
}
