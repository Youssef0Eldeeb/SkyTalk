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
    var newMessageListener: ListenerRegistration!
    
    private init() {}
    
    func addMessageToFirestore(_ message: LocalMessage, memberId: String){
        do{
            try FirestoreManager.shared.FirestorReference(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        }catch{
            print(error.localizedDescription)
        }
    }
    func getOldMessages(userId documentId: String,chatId collectionId: String){
        FirestoreManager.shared.FirestorReference(.Message).document(documentId).collection(collectionId).getDocuments { querySnapShot, error in
            guard let documents = querySnapShot?.documents else {return}
            var oldMessages = documents.compactMap { snapShot -> LocalMessage? in
                return try? snapShot.data(as: LocalMessage.self)
            }
            oldMessages.sort(by: {$0.date < $1.date})
            for message in oldMessages{
                RealmManager.shared.save(message)
            }
        }
    }
    func listenForNewMessages(userId documentId: String,chatId collectionId: String, lastMessageDate: Date){
        newMessageListener =  FirestoreManager.shared.FirestorReference(.Message).document(documentId).collection(collectionId).whereField(MSGType.date.rawValue, isGreaterThan: lastMessageDate).addSnapshotListener({ querySnapshot, error in
            guard let snapshot = querySnapshot else {return}
            for change in snapshot.documentChanges{
                if change.type == .added{
                    let result = Result {
                        try? change.document.data(as: LocalMessage.self)
                    }
                    switch result {
                    case .success(let success):
                        if let message = success{
                            if message.senderId != FirebaseAuthentication.shared.currntId{
                                RealmManager.shared.save(message)
                            }
                        }
                    case .failure(let failure):
                        print(failure.localizedDescription)
                    }
                    
                }
            }
            
        })
    }
    func removeNewMessageListener(){
        self.newMessageListener.remove()
    }
    
}
