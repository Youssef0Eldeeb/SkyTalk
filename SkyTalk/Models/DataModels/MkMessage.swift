//
//  MkMessage.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 27/09/2022.
//

import Foundation
import MessageKit

class MkMessage: NSObject, MessageType{
    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var mkSender: MKSender
    var sender: SenderType {return mkSender}
    var senderInitials: String
    var status: String
    var readDate: Date
    var incoming: Bool
    
    var photoItem: PhotoMessage?
    
    init (message: LocalMessage){
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.status = message.status
        self.kind = MessageKind.text(message.message)
        self.senderInitials = message.senderInitials
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = FirebaseAuthentication.shared.currntId != mkSender.senderId
        
        switch message.type {
        case MSGType.text.rawValue:
            self.kind = MessageKind.text(message.message)
        case MSGType.photo.rawValue:
            let photoItem = PhotoMessage(path: message.pictureUrl)
            self.kind = MessageKind.photo(photoItem)
        default:
            print("there is error")
        }
        
    }

    
    
}
