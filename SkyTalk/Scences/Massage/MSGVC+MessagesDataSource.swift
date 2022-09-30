//
//  MSGVC+MessagesDataSource.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 27/09/2022.
//

import Foundation
import MessageKit


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
    
    
}
