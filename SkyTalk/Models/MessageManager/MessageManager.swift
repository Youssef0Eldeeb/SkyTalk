//
//  MessageManager.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 29/09/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore


enum MSGType: String{
    case text
    case photo
    case video
    case audio
    case location
    case date
}

class MessageManager {
    
    static let shared = MessageManager()
    
    private init() {}
    
    func addMessage(_ message: LocalMessage, memberId: String){
        do{
            try FirestoreManager.shared.FirestorReference(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
