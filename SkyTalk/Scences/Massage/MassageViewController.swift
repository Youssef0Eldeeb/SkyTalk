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
    let refreshController = UIRefreshControl()
    let micButton = InputBarButtonItem()
    let currentUser = MKSender(senderId: FirebaseAuthentication.shared.currntId, displayName: FirebaseAuthentication.shared.currentUser!.name)
    let mkMessage: [MkMessage] = []
    
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
        configureMessageCollectionView()
        configureMessageInputBar()
    }
    
    private func configureMessageCollectionView(){
        messagesCollectionView.messagesDataSource = self
         messagesCollectionView.messageCellDelegate = self
         messagesCollectionView.messagesDisplayDelegate = self
         messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.refreshControl = refreshController
        
    }
    private func configureMessageInputBar(){
        messageInputBar.delegate = self
        let attachedButton = InputBarButtonItem()
        attachedButton.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        attachedButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachedButton.onTouchUpInside { item in
            print("Done Pressed Inside")
        }
        
        
        micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        messageInputBar.setStackViewItems([attachedButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 35, animated: false)
        
        updateMicButtonStatus(show: false)
//        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }
    private func updateMicButtonStatus(show: Bool){
        if show{
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
            
        }else{
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
}
