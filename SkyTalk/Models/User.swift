//
//  User.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 10/09/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable{
    var id: String = ""
    var pushId: String = ""
    var imageLink: String = ""
    var name, email, status: String
    
    
//    func toDictionary() -> [String:Any]{
//        if let jsonDecodedObj = try? JSONEncoder().encode(self){
//            return try! JSONSerialization.jsonObject(with: jsonDecodedObj) as! [String:Any]
//        }
//        return [:]
//    }
}
