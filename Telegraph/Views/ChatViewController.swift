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
    
}
