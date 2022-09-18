//
//  FileManager.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 18/09/2022.
//

import Foundation

class FileDocumentManager{
    
    static let shared = FileDocumentManager()
    
    func saveFileLocally(fileData: NSData, fileName: String){
        let decUrl = getDecumentURL().appendingPathComponent(fileName, isDirectory: false)
        fileData.write(to: decUrl, atomically: true)
    }
    
    //Create folder and return the its URL
    func getDecumentURL() -> URL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }
    //Create file and return the its path
    func getFilePath(fileName: String) -> String{
        return getDecumentURL().appendingPathComponent(fileName).path
    }
    
    func fileExistsAtPath(path: String) -> Bool{
        return FileManager.default.fileExists(atPath: getFilePath(fileName: path))
    }
    
}
