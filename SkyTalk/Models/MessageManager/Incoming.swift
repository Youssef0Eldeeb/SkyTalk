//
//  Incoming.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 30/09/2022.
//

import Foundation
import MessageKit

class Incoming {
    var messageViewController: MessagesViewController
    
    init(messageViewController: MessagesViewController) {
        self.messageViewController = messageViewController
    }
    
    func createMKMessage(localMessage: LocalMessage) -> MkMessage{
        let mkMessage = MkMessage(message: localMessage)
        
        if localMessage.type == MSGType.photo.rawValue{
            let photoItem = PhotoMessage(path: localMessage.pictureUrl)
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            FileStorageManager.downloadImage(imageUrl: localMessage.pictureUrl) { image in
                mkMessage.photoItem?.image = image
                self.messageViewController.messagesCollectionView.reloadData()
            }
        }
        
        return mkMessage
    }
}
