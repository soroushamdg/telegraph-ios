//
//  IncomingMessage.swift
//  Telegraph
//
//  Created by Soro on 2022-12-13.
//

import Foundation
import MessageKit
import CoreLocation


class IncomingMessage {
    var messageCollectionView: MessagesViewController
    
    init(_collectionView: MessagesViewController){
        messageCollectionView = _collectionView
    }
    
    //MARK: CREATE MESSAGE
    func createMessage(localMessage: LocalMessage) -> MKMessage? {
        let mkMessage = MKMessage(message: localMessage)
        
        return mkMessage
    }
}
