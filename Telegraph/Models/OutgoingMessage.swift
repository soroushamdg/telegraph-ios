//
//  OutgoingMessage.swift
//  Telegraph
//
//  Created by Soro on 2022-11-28.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

class OutgoingMessage {
    class func send(chatId: String, text: String?, photo: UIImage?, video: String?, audio: String?, location: String?, audioDuration: Float = 0.0, memberIds: [String]){
        
        let currentUser = User.currentUser!
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderInitials = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSENT
        
        if text != nil {
            // send text message
            sendTextMessage(message: message, text: text!, memberIds: memberIds)
        }
        
    }
    class func sendMessage(message: LocalMessage, memberIds: [String]){
        RealmManager.shared.saveToRealm(message)
        
        for memberId in memberIds {
            FirebaseMessageListener.shared.addMessage(message, memberId: memberId)
        }
    }
}

func sendTextMessage(message: LocalMessage, text: String, memberIds: [String]){
    message.message = text
    message.type = kTEXT
    OutgoingMessage.sendMessage(message: message, memberIds: memberIds)
}
