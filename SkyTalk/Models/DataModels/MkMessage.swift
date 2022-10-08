//
//  MkMessage.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 27/09/2022.
//

import Foundation
import MessageKit
import CoreLocation

class MkMessage: NSObject, MessageType{
    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var mkSender: MKSender
    var sender: SenderType {return mkSender}
    var senderInitials: String
    var senderImageLink: String
    var status: String
    var readDate: Date
    var incoming: Bool
    
    var photoItem: PhotoMessage?
    var videoItem: VideoMessage?
    var locationItem: LocationMessage?
    var audioItem: AudioMessage?
    
    init (message: LocalMessage){
        self.messageId = message.id
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.status = message.status
        self.kind = MessageKind.text(message.message)
        self.senderInitials = message.senderInitials
        self.senderImageLink = message.senderImageLink
        self.sentDate = message.date
        self.readDate = message.readDate
        self.incoming = FirebaseAuthentication.shared.currntId != mkSender.senderId
        
        switch message.type {
        
        case MSGType.text.rawValue:
            self.kind = MessageKind.text(message.message)
        
        case MSGType.photo.rawValue:
            let photoItem = PhotoMessage(path: message.pictureUrl)
            self.kind = MessageKind.photo(photoItem)
            self.photoItem = photoItem
        
        case MSGType.video.rawValue:
            let videoItem = VideoMessage(url: nil)
            self.kind = MessageKind.video(videoItem)
            self.videoItem = videoItem
        
        case MSGType.location.rawValue:
            let locationItem = LocationMessage(location: CLLocation(latitude: message.latitude, longitude: message.logitude))
            self.kind = MessageKind.location(locationItem)
            self.locationItem = locationItem
            
        case MSGType.audio.rawValue:
            let audioItem = AudioMessage(duration: 2.0)
            self.kind = MessageKind.audio(audioItem)
            self.audioItem = audioItem
            
        default:
            self.kind = MessageKind.text(message.message)
            print("there is error")
        }
        
    }

    
    
}
