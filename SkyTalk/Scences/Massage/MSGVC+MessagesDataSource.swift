//
//  MSGVC+MessagesDataSource.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 27/09/2022.
//

import Foundation
import MessageKit
import UIKit


extension MassageViewController: MessagesDataSource{
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        
        if indexPath.section % 14 == 0 {
            let showLoadMore = (indexPath.section == 0) && (allLocalMessages .count > displayingMessagesCount)
            let sentDate = MessageKitDateFormatter.shared.string(from: message.sentDate)
            
            
            
            var text = ""
            var font = UIFont()
            var color = UIColor()
            
            if showLoadMore {
                text = "Pull to load more"
                font = UIFont.systemFont(ofSize: 13)
                color = UIColor.systemBlue
            }else{
                text = sentDate
                font = UIFont.boldSystemFont(ofSize: 10)
                color = UIColor.darkGray
            }
            return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isFromCurrentSender(message: message){
            let message = mkMessages[indexPath.section]
            let status = indexPath.section == mkMessages.count - 1 ? message.status + " " + message.readDate.MSGTime() : ""
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            
            return NSAttributedString(string: status, attributes: [.font: font, .foregroundColor: color])
        }
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section != mkMessages.count - 1 {
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(string: message.sentDate.MSGTime(), attributes: [.font: font, .foregroundColor: color])
        }
        return nil
    }
    
}
