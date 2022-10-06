//
//  MessageViewController+.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 04/10/2022.
//

import Foundation
import UIKit
import Gallery

extension MassageViewController{
    
    func actionAttechedMessage() {
        
        messageInputBar.inputTextView.resignFirstResponder()
        
        let optionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotoOrVideo = UIAlertAction(title: "Camera", style: .default) { alert in
            self.showImageCallery(camera: true)
        }
        let shareMedia = UIAlertAction(title: "Library", style: .default) { alert in
            self.showImageCallery(camera: false)
        }
        let shareLocation = UIAlertAction(title: "Location", style: .default) { alert in
            if let _ = LocationManager.shared.currentLocation {
//                self.send(text: nil, photo: nil, video: nil, audio: nil, location: MSGType.location.rawValue)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        takePhotoOrVideo.setValue(UIImage(systemName: "camera.viewfinder"), forKey: "image")
        shareMedia.setValue(UIImage(systemName: "photo.on.rectangle.angled"), forKey: "image")
        shareLocation.setValue(UIImage(systemName: "mappin.and.ellipse"), forKey: "image")
        
        optionsMenu.addAction(takePhotoOrVideo)
        optionsMenu.addAction(shareMedia)
        optionsMenu.addAction(shareLocation)
        optionsMenu.addAction(cancel)
        
        self.present(optionsMenu, animated: true)
    }
    
    func showImageCallery(camera: Bool){
        gallery = GalleryController()
        gallery.delegate = self
        Config.tabsToShow = camera ? [.cameraTab] : [.imageTab, .videoTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        Config.VideoEditor.maximumDuration = 60
        
        self.present(gallery, animated: true)
    }
    
}

extension MassageViewController: GalleryControllerDelegate{
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            images.first!.resolve { image in
                self.send(text: nil, photo: image, video: nil, audio: nil, location: nil)
            }
        }
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
        self.send(text: nil, photo: nil, video: video, audio: nil, location: nil)
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
        controller.dismiss(animated: true)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        
        controller.dismiss(animated: true)
    }
    
    
}
