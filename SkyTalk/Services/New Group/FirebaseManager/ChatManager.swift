//
//  ChatManager.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 24/09/2022.
//

import Foundation


class ChatManager{
    
    static let shared = ChatManager()
    
    let chatRoomIdKey = "chatRoomId"
    let senderIdKey = "senderId"
    let currentUser = FirebaseAuthentication.shared.currentUser
    let currentId = FirebaseAuthentication.shared.currntId
    
    func startChat(sender: User, receiver: User) -> String{
        var chatRoomId = ""
        let value = sender.id.compare(receiver.id).rawValue
        chatRoomId = value < 0 ? (sender.id + receiver.id) : (receiver.id + sender.id)
        createChatRoom(chatRoomId: chatRoomId, users: [sender, receiver])
        
        return chatRoomId
    }
    
    func restartChat(chatRoomId: String, membersIds: [String]){
        FirestoreManager.shared.downloadUsersFromFBWithID(usersId: membersIds) { allUsers in
            if allUsers.count > 0 {
                self.createChatRoom(chatRoomId: chatRoomId, users: allUsers)
            }
        }
    }
    
    func createChatRoom(chatRoomId: String, users: [User]){
        var usersToCreatChat: [String] = []
        for user in users {
            usersToCreatChat.append(user.id)
        }
        FirestoreManager.shared.FirestorReference(.Chat).whereField(chatRoomIdKey, isEqualTo: chatRoomId).getDocuments { [self] quarySnapshot, error in
            guard let snapshot = quarySnapshot else {return}
            if !snapshot.isEmpty{
                for chatData in snapshot.documents{
                    let currentChat = chatData.data() as Dictionary
                    if let currentUserId = currentChat[senderIdKey]{
                        if usersToCreatChat.contains(currentUserId as! String){
                            usersToCreatChat.remove(at: usersToCreatChat.firstIndex(of: currentUserId as! String)!)
                        }
                    }
                }
            }
            for userId in usersToCreatChat{
                let senderUser = userId == currentId ? currentUser! : getReciever(users: users)
                let receiverUser = userId == currentId ? getReciever(users: users) : currentUser!
                
                let chatRoomObject = ChatRoom(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.name, receiverId: receiverUser.id, receiverName: receiverUser.name, date: Date(), memberId: [senderUser.id, receiverUser.id], lastMessage: "", unReadCounter: 0, avatarLink: receiverUser.imageLink)
                
                saveChatRoom(chatRoomObject)
            }
        }
    }
    
    func getReciever(users: [User]) -> User{
        var allUsers = users
        allUsers.remove(at: allUsers.firstIndex(of: currentUser!)!)
        return allUsers.first!
    }
    
    func saveChatRoom(_ chatRoom: ChatRoom){
        do {
            try FirestoreManager.shared.FirestorReference(.Chat).document(chatRoom.id).setData(from: chatRoom)
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func downloadChatRooms(completion: @escaping (_ allChatRooms: [ChatRoom]) -> (Void)){
        FirestoreManager.shared.FirestorReference(.Chat).whereField(senderIdKey, isEqualTo: currentId).addSnapshotListener { querySnapshot, error in
            var chatRooms: [ChatRoom] = []
            guard let documents = querySnapshot?.documents else {return}
            let allChatRoom = documents.compactMap { snapshot -> ChatRoom? in
                return try? snapshot.data(as: ChatRoom.self)
            }
            for chatRoom in allChatRoom{
                if chatRoom.lastMessage != ""{
                    chatRooms.append(chatRoom)
                }
            }
            chatRooms.sort(by: {$0.date! > $1.date!})
            completion(chatRooms)
        }
        
    }
    
    func downloadAllFBChatRooms(completion: @escaping (_ allChatRooms: [ChatRoom]) -> (Void)){
        FirestoreManager.shared.FirestorReference(.Chat).whereField(senderIdKey, isEqualTo: currentId).addSnapshotListener { querySnapshot, error in
            var chatRooms: [ChatRoom] = []
            guard let documents = querySnapshot?.documents else {return}
            let allChatRoom = documents.compactMap { snapshot -> ChatRoom? in
                return try? snapshot.data(as: ChatRoom.self)
            }
            for chatRoom in allChatRoom{
                chatRooms.append(chatRoom)
            }
            completion(chatRooms)
        }
        
    }
    
    func deletChatRoom(_ chatRoom: ChatRoom){
        FirestoreManager.shared.FirestorReference(.Chat).document(chatRoom.id).delete()
    }
    // clear unread counter and update chatroom
    private func clearUnreadCounter(chatRoom: ChatRoom){
        var newChatRoom = chatRoom
        newChatRoom.unReadCounter = 0
        self.saveChatRoom(newChatRoom)
    }
    
    func clearUnreadCounterByChatRoomId(chatRoomId: String){
        FirestoreManager.shared.FirestorReference(.Chat).whereField(senderIdKey, isEqualTo: currentId).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {return}
            let comingChatRooms = documents.compactMap { query -> ChatRoom? in
                return try? query.data(as: ChatRoom.self)
            }
//            print( "\n" , comingChatRooms.first!.receiverName , "\n")
//            print( "\n" , comingChatRooms.count , "\n")
//            print( "\n" , comingChatRooms.last!.receiverName, "\n")
            if comingChatRooms.count > 0 {
                let filteredChatRoom = comingChatRooms.filter { chatRoom in
                    chatRoom.chatRoomId == chatRoomId
                }
                print( "\n" , filteredChatRoom.first! , "\n")
                print( "\n" , filteredChatRoom.last! , "\n")
                self.clearUnreadCounter(chatRoom: filteredChatRoom.first!)
            }
        }
    }
    
    private func updateChatRoomByNewMessage(chatRoom: ChatRoom, lastMessage: String){
        var tempChatRoom = chatRoom
        if tempChatRoom.senderId != currentId{
            tempChatRoom.unReadCounter += 1
        }
        tempChatRoom.lastMessage = lastMessage
        tempChatRoom.date = Date()
        self.saveChatRoom(tempChatRoom)
    }
    
    func updateChatRooms(chatRoomId: String, lastMessage: String){
        FirestoreManager.shared.FirestorReference(.Chat).whereField(chatRoomIdKey, isEqualTo: chatRoomId).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {return}
            let comingChatRooms = documents.compactMap { query -> ChatRoom? in
                return try? query.data(as: ChatRoom.self)
            }
            for chatRoom in comingChatRooms{
                self.updateChatRoomByNewMessage(chatRoom: chatRoom, lastMessage: lastMessage)
            }
        }
    }
//    func getReciverUser(chatRoomId: String){
//
//    }
    
}
