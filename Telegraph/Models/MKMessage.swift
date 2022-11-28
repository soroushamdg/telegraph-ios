//
//  MKMessage.swift
//  Telegraph
//
//  Created by Soro on 2022-11-28.
//

import Foundation
import MessageKit
import CoreLocation

class MKMessage : NSObject, MessageType {
    
    var mkSender: MKSender
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
    var incoming: Bool
    var sender: SenderType { return mkSender }
    var senderInitials: String
    
//    var photoMessage: PhotoMessage
    
    var status: String //sent, read
    var readDate: Date
    
    init(message: LocalMessage) {
        super.init()
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.status = message.status
        self.kind = MessageKind.text(message.message)
        
//        switch message.type {
//        case:
//        default:
//        }
        self.senderInitials = message.senderInitials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = User.currentId != mkSender.senderId
    }
}
