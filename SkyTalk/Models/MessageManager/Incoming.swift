//
//  Incoming.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 30/09/2022.
//

import Foundation
import MessageKit
import CoreLocation

class Incoming {
    var messageViewController: MessagesViewController
    
    init(messageViewController: MessagesViewController) {
        self.messageViewController = messageViewController
    }
    
    func createMKMessage(localMessage: LocalMessage) -> MkMessage{
        let mkMessage = MkMessage(message: localMessage)
        
        if localMessage.type == MSGType.photo.rawValue{
            let photoItem = PhotoMessage(path: localMessage.pictureUrl)
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            FirebaseStorageManager.downloadImage(imageUrl: localMessage.pictureUrl) { image in
                mkMessage.photoItem?.image = image
                self.messageViewController.messagesCollectionView.reloadData()
            }
        }
        
        if localMessage.type == MSGType.video.rawValue{
            FirebaseStorageManager.downloadImage(imageUrl: localMessage.pictureUrl) { image in
                FirebaseStorageManager.downloadVideo(videoUrl: localMessage.videoUrl) { readyToPlay, videoFileName in
                    let videoLink = URL(fileURLWithPath: FileDocumentManager.shared.getFilePath(fileName: videoFileName))
                    let videoItem = VideoMessage(url: videoLink)
                    
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                    mkMessage.videoItem?.image = image
                    self.messageViewController.messagesCollectionView.reloadData()
                }
            }
        }
        
        if localMessage.type == MSGType.location.rawValue{
            let locationItem = LocationMessage(location: CLLocation(latitude: localMessage.latitude, longitude: localMessage.logitude))
            mkMessage.kind = MessageKind.location(locationItem)
            mkMessage.locationItem = locationItem
        }
        
        if localMessage.type == MSGType.audio.rawValue{
            let audioMessage = AudioMessage(duration: Float(localMessage.audioDuration))
            mkMessage.audioItem = audioMessage
            mkMessage.kind = MessageKind.audio(audioMessage)
            FirebaseStorageManager.downloadAudio(audioUrl: localMessage.audioUrl) { audioFileName in
                let audioURl = URL(fileURLWithPath: FileDocumentManager.shared.getFilePath(fileName: audioFileName))
                mkMessage.audioItem?.url = audioURl
            }
            self.messageViewController.messagesCollectionView.reloadData()
        }
        
        return mkMessage
    }
}
