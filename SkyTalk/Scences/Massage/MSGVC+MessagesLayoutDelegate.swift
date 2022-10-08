//
//  MSGVC+MessagesLayoutDelegate.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 27/09/2022.
//

import Foundation
import MessageKit


extension MassageViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 14 == 0{
            if (indexPath.section == 0) && (allLocalMessages.count > displayingMessagesCount){
                return 40
            }
        }
        return 10
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 16 : 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return indexPath.section != mkMessages.count - 1 ? 10 : 0
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
        FirebaseStorageManager.downloadImage(imageUrl: mkMessages[indexPath.section].senderImageLink) { image in
            avatarView.set(avatar: Avatar(image: image, initials: self.mkMessages[indexPath.section].senderInitials))
        }
        
    }
    
    
    
}
