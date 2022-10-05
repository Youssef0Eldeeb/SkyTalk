//
//  MessageViewController+.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 04/10/2022.
//

import Foundation
extension MassageViewController{
    func loadMessages(){
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
    
    func insertMKMessage(localMessage: LocalMessage){
        markMessageAsReaded(localMessage)
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(localMessage: localMessage)
        self.mkMessages.append(mkMessage)
        displayingMessagesCount += 1
    }
    
    func insertOldMKMessage(localMessage: LocalMessage){
        let incoming = Incoming(messageViewController: self)
        let mkMessage = incoming.createMKMessage(localMessage: localMessage)
        self.mkMessages.insert(mkMessage, at: 0)
        displayingMessagesCount += 1
    }
    
    func insertMKMessages(){
        maxMessageNumber = allLocalMessages.count - displayingMessagesCount
        minMessageNumber = maxMessageNumber - 14
        if minMessageNumber < 0{
            minMessageNumber = 0
        }
        for i in minMessageNumber ..< maxMessageNumber{
            insertMKMessage(localMessage: allLocalMessages[i])
        }
    }
    func insertMoreMKMessages(){
        maxMessageNumber = minMessageNumber - 1
        minMessageNumber = maxMessageNumber - 14
        if minMessageNumber < 0{
            minMessageNumber = 0
        }
        for i in (minMessageNumber ... maxMessageNumber).reversed(){
            insertOldMKMessage(localMessage: allLocalMessages[i])
        }
    }
    func markMessageAsReaded(_ localMessage: LocalMessage){
        if localMessage.senderId != FirebaseAuthentication.shared.currntId{
            MessageManager.shared.updateMessgeStatus(localMessage, userId: recipientId)
        }
    }
    
    
    func getOldMessages(){
        MessageManager.shared.getOldMessages(userId: FirebaseAuthentication.shared.currntId, chatId: chatId)
    }
    func listenForNewMessages(){
        MessageManager.shared.listenForNewMessages(userId: FirebaseAuthentication.shared.currntId, chatId: chatId, lastMessageDate: lastMessageDate())
    }
    func lastMessageDate() -> Date  {
        let lastmessageDate = allLocalMessages.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second, value: 1, to: lastmessageDate) ?? lastmessageDate
    }
    func removeListeners(){
        TypingManager.shared.removeTypingListener()
        MessageManager.shared.removeNewMessageListener()
    }
    func updateReadStatus(_ updatedLocalMessage: LocalMessage){
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
    
    func listenForReadStatusUpdates(){
        MessageManager.shared.listenForReadStatus(FirebaseAuthentication.shared.currntId, collectionId: chatId) { updatedMessage in
            self.updateReadStatus(updatedMessage)
        }
    }
    
    // MARK: - Typing Indicator
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
    func stopTypingIndicator(){
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

