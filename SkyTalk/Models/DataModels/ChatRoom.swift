//
//  ChatRoom.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 22/09/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatRoom: Codable{
    var id: String = ""
    var chatRoomId: String = ""
    var senderId: String = ""
    var senderName: String = ""
    var receiverId: String = ""
    var receiverName: String = ""
    @ServerTimestamp var date = Date()
    var memberId: [String] = []
    var lastMessage: String = ""
    var unReadCounter: Int = 0
    var avatarLink: String = ""
}
