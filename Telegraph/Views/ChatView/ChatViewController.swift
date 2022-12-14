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
    
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    private var refreshController = UIRefreshControl()
    
    let micButton = InputBarButtonItem()
    let attachButton = InputBarButtonItem()
    
    var mkMessages: [MKMessage] = []
    var allLocalMessages: Results<LocalMessage>!
    
    let realm = try! Realm()
    
    //MARK: LISTENERS
    var notificationToken: NotificationToken!
    
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
        configureMessageInputBar()
        configureMessageCollectionView()
        
        loadChats()
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
        
        attachButton.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { item in
        }
        
        micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
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
    
    //MARK: LOAD CHATS
    private func loadChats() {
        let predicate = NSPredicate(format: "\(kCHATROOMID) = %@", chatId)
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: kDATE,ascending: true)
        
        notificationToken = allLocalMessages.observe({ (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.insertMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            case .update(_,_,let insertion,_):
                for index in insertion{
                    self.insertMessage(self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                }
            case .error(let error):
                print("Error on new insertion ", error.localizedDescription)
            default:
                break;
            }
        })
    }
    
    private func insertMessages() {
        for message in allLocalMessages {
            insertMessage(message)
        }
    }
    
    private func insertMessage(_ localMessage: LocalMessage) {
        let incoming = IncomingMessage(_collectionView: self)
        self.mkMessages.append(incoming.createMessage(localMessage: localMessage)!)
    }
    
    //MARK: ACTIONS
    func messageSend(text: String?, photo: UIImage?, video: String?, audio: String?, location: String?, audioDuration: Float = 0.0){
        OutgoingMessage.send(chatId: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberIds: [User.currentId, recipientId])
    }
    
}
