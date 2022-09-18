//
//  FileStorageManager.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 17/09/2022.
//

import Foundation
import FirebaseStorage

class FileStorageManager{
    
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ documentLink: String?) -> (Void)){
        
        let folderPath = "gs://skytalk-1f580.appspot.com"
        let storage = Storage.storage()
        
        let storageRef = storage.reference(forURL: folderPath).child(directory)
        let imageData = image.pngData()
        var task: StorageUploadTask!
        task = storageRef.putData(imageData!, completion: { storageMetaData, error in
            task.removeAllObservers()
            
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
    static func gitAcualFileName(fileUrl: String) -> String{
        let actualUrl = fileUrl.components(separatedBy: "_").last
        let nameWithExtension = actualUrl?.components(separatedBy: "?").first
        let actualName = nameWithExtension?.components(separatedBy: ".").first
        return actualName!
    }
}
