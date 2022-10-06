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
    
    var chatId = ""
    var recipientId = ""
    var recipientName = ""
    var recipientImageLink = ""
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
    
    var gallery: GalleryController!
    var longPressGesture: UILongPressGestureRecognizer!
    
    var audioFileName = ""
    var audioStartTime = Date()
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
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
        configureGestureRocognizer()
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
            self.actionAttechedMessage()
        }
        
        
        micButton.image = UIImage(systemName: "mic.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        micButton.setSize(CGSize(width: 30, height: 30), animated: false)
        
        micButton.addGestureRecognizer(longPressGesture)
        
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
        
        
//        print("\n" , Realm.Configuration.defaultConfiguration.fileURL! , "\n")
    }
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if refreshController.isRefreshing{
            if displayingMessagesCount < allLocalMessages.count{
                insertMoreMKMessages()
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
            FirebaseStorageManager.downloadImage(imageUrl: recipientImageLink) { image in
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
    
    private func configureGestureRocognizer(){
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(recordAndSend))
    }
    @objc func recordAndSend(){
        
        switch longPressGesture.state {
        case .began:
            audioFileName = Date().stringDate()
            audioStartTime = Date()
            AudioRecorder.shared.startRecording(fileName: audioFileName)
            
            print("Record")
        case .ended:
            AudioRecorder.shared.finishRecording()
            if FileDocumentManager.shared.fileExistsAtPath(path: audioFileName + ".m4a"){
                let audioDuration = audioStartTime.interval(ofComponent: .second, to: Date())
                send(text: nil, photo: nil, video: nil, audio: audioFileName, location: nil, audioDuration: audioDuration)
            }
            
            print("Send")
        @unknown default:
            print("unknown")
        }
        
    }
    
}
