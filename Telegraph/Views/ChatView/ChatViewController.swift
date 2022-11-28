//
//  ChatViewController.swift
//  Telegraph
//
//  Created by Soro on 2022-11-21.
//

import UIKit
import MessageKit
import Gallery
import InputBarAccessoryView
import RealmSwift

class ChatViewController: MessagesViewController {
    
    //MARK: VARS
    private var chatId : String = ""
    private var recipientId : String = ""
    private var recipientName : String = ""
    
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser?.username)
    private var refreshController = UIRefreshControl()
    
    let micButton = InputBarButtonItem()
    let attachButton = InputBarButtonItem()

    
    //MARK: INITIALIZERS
    init(chatId: String, recipientId: String, recipientName: String){
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recipientId = recipientId
        self.recipientName = recipientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: CONFIGURATION
    private func configureMessageCollectionView(){
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = self.refreshController
    }
    
    private func configureMessageInputBar(){
        messageInputBar.delegate = self
        
        attachButton.image = UIImage(systemName: "plus")
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { item in
        }
        
        micButton.image = UIImage(systemName: "mic.fill")
        micButton.setSize(CGSize(width: 30, height: 40), animated: false)
        micButton.onTouchUpInside { item in
        }
        
        messageInputBar.setStackViewItems([attachButton,], forStack: .left, animated: true)
        messageInputBar.setStackViewItems([micButton,], forStack: .right, animated: true)
        
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: true)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: true)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        
        messageInputBar.inputTextView.backgroundColor = .systemBackground

    }
    
}
