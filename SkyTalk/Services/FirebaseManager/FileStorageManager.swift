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
}
