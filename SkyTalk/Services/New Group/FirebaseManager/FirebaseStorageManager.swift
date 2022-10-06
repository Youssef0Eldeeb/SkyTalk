//
//  FileStorageManager.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 17/09/2022.
//

import Foundation
import FirebaseStorage
import ProgressHUD
import UIKit
import AVFoundation

class FirebaseStorageManager{
    
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ imageLink: String?) -> (Void)){
        
        let folderPath = "gs://skytalk-1f580.appspot.com"
        let storage = Storage.storage()
        
        let storageRef = storage.reference(forURL: folderPath).child(directory)
        let imageData = image.pngData()
        var task: StorageUploadTask!
        task = storageRef.putData(imageData!, completion: { storageMetaData, error in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil{
                print("Error Uploading Image : " + error!.localizedDescription)
            }
            storageRef.downloadURL { url, error in
                guard let downloadUrl = url else{
                    completion(nil)
                    return
                }
                completion(downloadUrl.absoluteString)
            }
        })
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }
    
    class func downloadImage(imageUrl: String, completion: @escaping (_ image: UIImage?) -> (Void)){
        let imageFileName = gitAcualFileName(fileUrl: imageUrl)
        if FileDocumentManager.shared.fileExistsAtPath(path: imageFileName){
            let imagePath = FileDocumentManager.shared.getFilePath(fileName: imageFileName)
            if let fileContent = UIImage(contentsOfFile: imagePath){
                completion(fileContent)
            }else{
                completion(nil)
            }
        }else{
            if imageUrl != ""{
                let documentUrl = URL(string: imageUrl)
                let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    if data != nil{
                        FileDocumentManager.shared.saveFileLocally(fileData: data!, fileName: imageFileName)
                        DispatchQueue.main.async {
                            completion(UIImage(data: data! as Data))
                        }
                    }else{
                        completion(nil)
                    }
                }
            }
        }
    }
    static func gitAcualFileName(fileUrl: String) -> String{
        let actualUrl = fileUrl.components(separatedBy: "_").last
        let nameWithExtension = actualUrl?.components(separatedBy: "?").first
        let actualName = nameWithExtension?.components(separatedBy: ".").first
        return actualName!
    }
    
    // Video Operaitons
    class func generateVideoThumbnail(url: URL) -> UIImage{
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            return UIImage(systemName: "photo")!
        }
    }
    
    class func uploadVideo(_ video: NSData, directory: String, completion: @escaping (_ videoLink: String?) -> (Void)){
        
        let folderPath = "gs://skytalk-1f580.appspot.com"
        let storage = Storage.storage()
        
        let storageRef = storage.reference(forURL: folderPath).child(directory)
        var task: StorageUploadTask!
        task = storageRef.putData(video as Data, completion: { storageMetaData, error in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            
            if error != nil{
                print("Error Uploading Image : " + error!.localizedDescription)
            }
            storageRef.downloadURL { url, error in
                guard let downloadUrl = url else{
                    completion(nil)
                    return
                }
                completion(downloadUrl.absoluteString)
            }
        })
        task.observe(StorageTaskStatus.progress) { snapshot in
            let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            ProgressHUD.showProgress(CGFloat(progress))
        }
    }
    
    class func downloadVideo(videoUrl: String, completion: @escaping (_ readyToPlay: Bool, _ videoFileName: String) -> (Void)){
        let videoFileName = gitAcualFileName(fileUrl: videoUrl) + ".mov"
        if FileDocumentManager.shared.fileExistsAtPath(path: videoFileName){
            completion(true, videoFileName)
        }else{
            if videoUrl != ""{
                let documentUrl = URL(string: videoUrl)
                let downloadQueue = DispatchQueue(label: "videoDownloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    if data != nil{
                        FileDocumentManager.shared.saveFileLocally(fileData: data!, fileName: videoFileName)
                        DispatchQueue.main.async {
                            completion(true, videoFileName)
                        }
                    }else{
                        print("no document founded in datebase")
                    }
                }
            }
        }
    }
    
    class func uploadAudio(_ audioFileName: String, directory: String, completion: @escaping (_ audioLink: String?) -> (Void)){
        let folderPath = "gs://skytalk-1f580.appspot.com"
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: folderPath).child(directory)
        let fileName = audioFileName + ".m4a"
        var task: StorageUploadTask!
        
        if FileDocumentManager.shared.fileExistsAtPath(path: fileName){
            if let audioData = NSData(contentsOfFile: FileDocumentManager.shared.getFilePath(fileName: fileName)){
                task = storageRef.putData(audioData as Data, completion: { storageMetaData, error in
                    task.removeAllObservers()
                    ProgressHUD.dismiss()
                    if error != nil{
                        print("Error Uploading audio : " + error!.localizedDescription)
                    }
                    storageRef.downloadURL { url, error in
                        guard let downloadUrl = url else{
                            completion(nil)
                            return
                        }
                        completion(downloadUrl.absoluteString)
                    }
                })
                task.observe(StorageTaskStatus.progress) { snapshot in
                    let progress = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
                    ProgressHUD.showProgress(CGFloat(progress))
                }
            }
        }else{
            print("Nothing to upload or file does not exist")
        }
    }
    
    class func downloadAudio(audioUrl: String, completion: @escaping (_ audioFileName: String) -> (Void)){
        let audioFileName = gitAcualFileName(fileUrl: audioUrl) + ".m4a"
        if FileDocumentManager.shared.fileExistsAtPath(path: audioFileName){
            completion(audioFileName)
        }else{
            if audioUrl != ""{
                let documentUrl = URL(string: audioUrl)
                let downloadQueue = DispatchQueue(label: "audioDownloadQueue")
                downloadQueue.async {
                    let data = NSData(contentsOf: documentUrl!)
                    if data != nil{
                        FileDocumentManager.shared.saveFileLocally(fileData: data!, fileName: audioFileName)
                        DispatchQueue.main.async {
                            completion(audioFileName)
                        }
                    }else{
                        print("no document founded in datebase")
                    }
                }
            }
                
        }
    }
    
}
