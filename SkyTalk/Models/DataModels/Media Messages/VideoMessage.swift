//
//  VideoMessage.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 05/10/2022.
//

import Foundation
import MessageKit

class VideoMessage: NSObject, MediaItem{
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(url: URL?){
        self.url = url
        self.placeholderImage = UIImage(systemName: "photo")!
        self.size = CGSize(width: 240, height: 240)
    }
    
}
