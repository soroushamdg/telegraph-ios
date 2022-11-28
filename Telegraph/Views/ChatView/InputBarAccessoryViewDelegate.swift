//
//  InputBarAccessoryViewDelegate.swift
//  Telegraph
//
//  Created by Soro on 2022-11-28.
//

import Foundation
import InputBarAccessoryView

extension ChatViewController:  InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                print("send message with text ", text)
            }
        }
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
}

