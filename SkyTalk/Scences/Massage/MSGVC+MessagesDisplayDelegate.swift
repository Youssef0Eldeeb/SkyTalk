//
//  MSGVC+MessagesDisplayDelegate.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 27/09/2022.
//

import Foundation
import MessageKit


extension MassageViewController: MessagesDisplayDelegate{
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .label
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let outgoingBubbleColor = UIColor(named: "colorOutgoingBubble") ?? .green
        let incomingBubbleColor = UIColor(named: "colorIncomingBubble") ?? .darkGray
        return isFromCurrentSender(message: message) ? outgoingBubbleColor : incomingBubbleColor
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
}
