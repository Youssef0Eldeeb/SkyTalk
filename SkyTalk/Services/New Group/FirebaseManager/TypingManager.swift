//
//  TypingManager.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 03/10/2022.
//

import Foundation
import FirebaseFirestore

class TypingManager{
    
    static let shared = TypingManager()
    var typingListener: ListenerRegistration!
    var currentId = FirebaseAuthentication.shared.currntId
    private init () {}
    
    func createTypingObserver(chatRoomId: String, completion: @escaping (_ isTyping: Bool) -> (Void)){
        typingListener = FirestoreManager.shared.FirestorReference(.Typing).document(chatRoomId).addSnapshotListener({ documentSnapshot, error in
            guard let snapshot = documentSnapshot else {return}
            if snapshot.exists{
                for data in snapshot.data()!{
                    if data.key != self.currentId{
                        completion(data.value as! Bool)
                    }
                }
            }else{
                completion(false)
                FirestoreManager.shared.FirestorReference(.Typing).document(chatRoomId).setData([self.currentId: false])
            }
        })
    }
    
    func saveTypingCounter(typing: Bool, chatRoomId: String){
        FirestoreManager.shared.FirestorReference(.Typing).document(chatRoomId).updateData([currentId: typing])
    }
    
    func removeTypingListener(){
        self.typingListener.remove()
    }
    
    
}
