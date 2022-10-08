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
    
    
    func sendMessage(chatId: String, text: String?, photo: UIImage?, video: Video?, audio: String?, audioDuration: Float = 0.0, location:String?, memberIds: [String]){
        
        let currentUser = FirebaseAuthentication.shared.currentUser!
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.name
        message.senderInitials = String(currentUser.name.first!)
        message.senderImageLink = String(currentUser.imageLink)
        message.date = Date()
        message.status = sendKey
        
        if text != nil{
            sendText(memberIds: memberIds, message: message, text: text!)
        }
        if photo != nil{
            sendPhoto(message: message, photo: photo!, memberIds: memberIds)
        }
        if video != nil{
            sendVideo(message: message, video: video!, memberIds: memberIds)
        }
        if location != nil{
            sendLocation(message: message, memberIds: memberIds)
        }
        if audio != nil{
            sendAudio(message: message, audioFileName: audio!, audioDuration: audioDuration, memberIds: memberIds)
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
    
    func sendPhoto(message: LocalMessage, photo: UIImage, memberIds: [String]){
        message.message = "Photo Message"
        message.type = MSGType.photo.rawValue
        
        let fileName = Date().stringDate()
        let fileDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".png"
        FileDocumentManager.shared.saveFileLocally(fileData: photo.pngData()! as NSData, fileName: fileName)
        FirebaseStorageManager.uploadImage(photo, directory: fileDirectory) { imageLink in
            if imageLink != nil{
                message.pictureUrl = imageLink!
                self.saveMessageToRealm(message: message, memberIds: memberIds)
                self.saveMessageToFirestor(message: message, memberIds: memberIds)
            }
        }
        
    }
    
    func sendVideo(message: LocalMessage, video: Video, memberIds: [String]){
        message.message = "Video Message"
        message.type = MSGType.video.rawValue
        
        let fileName = Date().stringDate()
        let thumbnailDirectory = "MediaMessages/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".png"
        let videoDirectory = "MediaMessages/Video/" + "\(message.chatRoomId)" + "_\(fileName)" + ".mov"
        
        let editor = VideoEditor()
        editor.process(video: video) { video, tempPath in
            if let tempPath = tempPath {
                let thumbnail = FirebaseStorageManager.generateVideoThumbnail(url: tempPath)
                FileDocumentManager.shared.saveFileLocally(fileData: thumbnail.pngData()! as NSData, fileName: fileName)
                FirebaseStorageManager.uploadImage(thumbnail, directory: thumbnailDirectory) { imageLink in
                    if imageLink != nil{
                        let videoData = NSData(contentsOfFile: tempPath.path)
                        FileDocumentManager.shared.saveFileLocally(fileData: videoData!, fileName: fileName + ".mov")
                        FirebaseStorageManager.uploadVideo(videoData!, directory: videoDirectory) { videoLink in
                            message.videoUrl = videoLink ?? ""
                            message.pictureUrl = imageLink ?? ""
                            self.saveMessageToRealm(message: message, memberIds: memberIds)
                            self.saveMessageToFirestor(message: message, memberIds: memberIds)
                        }
                    }
                }
            }
        }
    }
    
    func sendLocation(message: LocalMessage, memberIds: [String]){
        let currentLocation = LocationManager.shared.currentLocation
        
        message.type = MSGType.location.rawValue
        message.message = "Location Message"
        message.latitude = currentLocation?.latitude ?? 0.0
        message.logitude = currentLocation?.longitude ?? 0.0
        
        saveMessageToRealm(message: message, memberIds: memberIds)
        saveMessageToFirestor(message: message, memberIds: memberIds)
    }
    
    func sendAudio(message: LocalMessage, audioFileName: String, audioDuration: Float, memberIds: [String]){
        message.message = "Audio Message"
        message.type = MSGType.audio.rawValue
        let fileDirectory = "MediaMessages/Audio/" + "\(message.chatRoomId)" + "_\(audioFileName)" + ".m4a"
        FirebaseStorageManager.uploadAudio(audioFileName, directory: fileDirectory) { audioLink in
            if audioLink != nil{
                message.audioUrl = audioLink ?? ""
                message.audioDuration = Double(audioDuration)
                self.saveMessageToRealm(message: message, memberIds: memberIds)
                self.saveMessageToFirestor(message: message, memberIds: memberIds)
            }
        }
    }
    
}
