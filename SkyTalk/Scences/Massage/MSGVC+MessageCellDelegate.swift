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
}
