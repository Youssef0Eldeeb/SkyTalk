//
//  MSGVC+MessageCellDelegate.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 27/09/2022.
//

import Foundation
import MessageKit
import AVFoundation
import AVKit
import SKPhotoBrowser

extension MassageViewController: MessageCellDelegate{
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell){
            let mkmessage = mkMessages[indexPath.section]
            if mkmessage.photoItem != nil && mkmessage.photoItem?.image != nil {
                var images = [SKPhoto]()
                let photo = SKPhoto.photoWithImage(mkmessage.photoItem!.image!)
                images.append(photo)
                let browser = SKPhotoBrowser(photos: images)
                present(browser, animated: true)
                
            }
            if mkmessage.videoItem != nil && mkmessage.videoItem?.url != nil {
                let playerController = AVPlayerViewController()
                let player = AVPlayer(url: mkmessage.videoItem!.url!)
                playerController.player = player
                
                let session = AVAudioSession.sharedInstance()
                try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
                
                present(playerController, animated: true) {
                    playerController.player!.play()
                }
            }
        }
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell){
            let mkMessage = mkMessages[indexPath.section]
            if mkMessage.locationItem != nil{
                let mapView = MapViewController()
                mapView.location = mkMessage.locationItem?.location
                navigationController?.pushViewController(mapView, animated: true)
            }
        }
    }
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        guard
          let indexPath = messagesCollectionView.indexPath(for: cell),
          let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView)
        else {
          print("Failed to identify message when audio cell receive tap gesture")
          return
        }
        guard audioController.state != .stopped else {
          // There is no audio sound playing - prepare to start playing for given audio message
          audioController.playSound(for: message, in: cell)
          return
        }
        if audioController.playingMessage?.messageId == message.messageId {
          // tap occur in the current cell that is playing audio sound
          if audioController.state == .playing {
            audioController.pauseSound(for: message, in: cell)
          } else {
            audioController.resumeSound()
          }
        } else {
          // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
          audioController.stopAnyOngoingPlaying()
          audioController.playSound(for: message, in: cell)
        }
      }
    
}
