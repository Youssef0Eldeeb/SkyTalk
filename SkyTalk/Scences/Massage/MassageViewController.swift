//
//  MassageViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 22/09/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class MassageViewController: MessagesViewController {
    
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    
    init(chatId: String, resipientId: String, recipientName: String) {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recipientId = resipientId
        self.recipientName = recipientName
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}
