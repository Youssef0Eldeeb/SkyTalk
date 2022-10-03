//
//  MassageViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 22/09/2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift

class MassageViewController: MessagesViewController {
    
    private var chatId = ""
    private var recipientId = ""
    private var recipientName = ""
    private var recipientImageLink = ""
    let refreshController = UIRefreshControl()
    let micButton = InputBarButtonItem()
    let currentUser = MKSender(senderId: FirebaseAuthentication.shared.currntId, displayName: FirebaseAuthentication.shared.currentUser!.name)
    var mkMessages: [MkMessage] = []
    var allLocalMessages: Results<LocalMessage>!
    let realm = try! Realm()
    var notificationToken: NotificationToken?
    
    var displayingMessagesCount = 0
    var maxMessageNumber = 0
    var minMessageNumber = 0
    var typingCounter = 0
    
    init(chatId: String, resipientId: String, recipientName: String, recipientImageLink: String) {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recipientId = resipientId
        self.recipientName = recipientName
        self.recipientImageLink = recipientImageLink
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageCollectionView()
        configureMessageInputBar()
        configureCustomTitle()
        
        loadMessages()
        listenForNewMessages()
        createTypingObserver()
        listenForReadStatusUpdates()
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func configureMessageCollectionView(){
        messagesCollectionView.messagesDataSource = self
         messagesCollectionView.messageCellDelegate = self
         messagesCollectionView.messagesDisplayDelegate = self
         messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
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
        
        updateMicButtonStatus(show: true)
//        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }
    
    func updateMicButtonStatus(show: Bool){
        if show{
            messageInputBar.setStackViewItems([micButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
            
        }else{
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
    func send(text: String?, photo: UIImage?, video: Video?, audio: String?, location: String?, audioDuration: Float = 0.0){
        Outgoing().sendMessage(chatId: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberIds: [FirebaseAuthentication.shared.currntId, recipientId])
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshController.isRefreshing{
            if displayingMessagesCount < allLocalMessages.count{
                insertMKMessages()
                messagesCollectionView.reloadDataAndKeepOffset()
            }
        }
        refreshController.endRefreshing()
    }
    
    // view customize
    let leftBarButtonView: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
    }()
    
    let titleLabel: UILabel = {
        let title = UILabel(frame: CGRect(x: 50, y: 0, width: 100, height: 25))
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    let subTitleLabel: UILabel = {
        let title = UILabel(frame: CGRect(x: 50, y: 22, width: 100, height: 20))
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        title.tintColor = .darkGray
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    let recipientImage: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.frame = CGRect(x: 5, y: 0, width: 40, height: 40)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func configureCustomTitle(){
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))]
        
        if recipientImageLink != ""{
            FileStorageManager.downloadImage(imageUrl: recipientImageLink) { image in
                self.recipientImage.image = image
            }
        }else{
            recipientImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.systemGray2)
        }
        titleLabel.text = self.recipientName
        subTitleLabel.text = ""
        leftBarButtonView.addSubview(titleLabel)
        leftBarButtonView.addSubview(subTitleLabel)
        leftBarButtonView.addSubview(recipientImage)
        
        let leftBarButtonItemView = UIBarButtonItem(customView: leftBarButtonView)
        self.navigationItem.leftBarButtonItems?.append(leftBarButtonItemView)
        
    }
    @objc func backButtonPressed(){
        removeListeners()
        ChatManager.shared.clearUnreadCounterByChatRoomId(chatRoomId: chatId)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func markMessageAsReaded(_ localMessage: LocalMessage){
        if localMessage.senderId != FirebaseAuthentication.shared.currntId{
            MessageManager.shared.updateMessgeStatus(localMessage, userId: recipientId)
        }
    }
    
    func updateTypingIndicator(_ show: Bool){
        subTitleLabel.text = show ? "Typing..." : ""
    }
    func startTypingIndicator(){
        typingCounter += 1
        TypingManager.shared.saveTypingCounter(typing: true, chatRoomId: chatId)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.stopTypingIndicator()
        }
    }
    private func stopTypingIndicator(){
        typingCounter -= 1
        if typingCounter == 0 {
            TypingManager.shared.saveTypingCounter(typing: false, chatRoomId: chatId)
        }
    }
    func createTypingObserver(){
        TypingManager.shared.createTypingObserver(chatRoomId: chatId) { isTyping in
            DispatchQueue.main.async {
                self.updateTypingIndicator(isTyping)
            }
        }
    }
    
}


extension MassageViewController{
    private func loadMessages(){
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: MSGType.date.rawValue)
        
        if allLocalMessages.isEmpty{
            getOldMessages()
        }
        
        notificationToken = allLocalMessages.observe({ change in
            switch change{
                
            case .initial(_):
                self.insertMKMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
                self.messagesCollectionView.scrollToBottom(animated: true)
            case .update(_, _,let insertions, _):
                for index in insertions{
                    self.insertMKMessage(localMessage: self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: false)
                    self.messagesCollectionView.scrollToBottom(animated: false)
                }
            case .error(let error):
                print( error.localizedDescription)
            }
        })
        
    }
    
    private func insertMKMessage(localMessage: LocalMessage){
        markMessageAsReaded(localMessage)
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(localMessage: localMessage)
        self.mkMessages.append(mkMessage)
        displayingMessagesCount += 1
    }
    
    private func insertOldMKMessage(localMessage: LocalMessage){
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(localMessage: localMessage)
        self.mkMessages.append(mkMessage)
        displayingMessagesCount += 1
    }
    
    private func insertMKMessages(){
        maxMessageNumber = allLocalMessages.count - displayingMessagesCount
        minMessageNumber = maxMessageNumber - 14
        if minMessageNumber < 0{
            minMessageNumber = 0
        }
        for i in minMessageNumber ..< maxMessageNumber{
            insertMKMessage(localMessage: allLocalMessages[i])
        }
    }
    private func insertMoreMKMessages(){
        maxMessageNumber = allLocalMessages.count  - 1
        minMessageNumber = maxMessageNumber - 14
        if minMessageNumber < 0{
            minMessageNumber = 0
        }
        for i in (minMessageNumber ... maxMessageNumber).reversed(){
            insertOldMKMessage(localMessage: allLocalMessages[i])
        }
    }
    
    
    
    private func getOldMessages(){
        MessageManager.shared.getOldMessages(userId: FirebaseAuthentication.shared.currntId, chatId: chatId)
    }
    private func listenForNewMessages(){
        MessageManager.shared.listenForNewMessages(userId: FirebaseAuthentication.shared.currntId, chatId: chatId, lastMessageDate: lastMessageDate())
    }
    private func lastMessageDate() -> Date  {
        let lastmessageDate = allLocalMessages.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second, value: 1, to: lastmessageDate) ?? lastmessageDate
    }
    private func removeListeners(){
        TypingManager.shared.removeTypingListener()
        MessageManager.shared.removeNewMessageListener()
    }
    private func updateReadStatus(_ updatedLocalMessage: LocalMessage){
        for index in 0 ..< mkMessages.count{
            let tempMessage = mkMessages[index]
            if updatedLocalMessage.id == tempMessage.messageId{
                mkMessages[index].status = updatedLocalMessage.status
                mkMessages[index].readDate = updatedLocalMessage.readDate
                
                RealmManager.shared.save(updatedLocalMessage)
                
                if mkMessages[index].status == readKey {
                    self.messagesCollectionView.reloadData()
                }
            }
        }
    }
    
    private func listenForReadStatusUpdates(){
        MessageManager.shared.listenForReadStatus(FirebaseAuthentication.shared.currntId, collectionId: chatId) { updatedMessage in
            self.updateReadStatus(updatedMessage)
        }
    }
}

