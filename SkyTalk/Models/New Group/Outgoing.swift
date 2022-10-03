//
//  Outgoing.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 29/09/2022.
//

import Foundation
import FirebaseFirestoreSwift
import Gallery


public let sendKey = "✔️"
public let readKey = "✔️✔️"

class Outgoing{
    
    
    func sendMessage(chatId: String, text: String?, photo: UIImage?, video: Video?, audio: String?, autioDuration: Float = 0.0, location:String?, memberIds: [String]){
        
        let currentUser = FirebaseAuthentication.shared.currentUser!
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.name
        message.senderInitials = String(currentUser.name.first!)
        message.date = Date()
        message.status = sendKey
        
        if text != nil{
            sendText(memberIds: memberIds, message: message, text: text!)
        }
        if photo != nil{
            
        }
        if video != nil{
            
        }
        if location != nil{
            
        }
        if audio != nil{
            
        }
        
        ChatManager.shared.updateChatRooms(chatRoomId: chatId, lastMessage: message.message)
        
    }
    private func sendText(memberIds: [String], message: LocalMessage, text: String){
        message.message = text
        message.type = MSGType.text.rawValue
        
        saveMessageToRealm(message: message, memberIds: memberIds)
        saveMessageToFirestor(message: message, memberIds: memberIds)
    }
    
    
    private func saveMessageToRealm(message: LocalMessage, memberIds: [String]){
        RealmManager.shared.save(message)
    }
    private func saveMessageToFirestor(message: LocalMessage, memberIds: [String]){
        for memberId in memberIds {
            MessageManager.shared.addMessageToFirestore(message, memberId: memberId)
        }
    }
    
}
