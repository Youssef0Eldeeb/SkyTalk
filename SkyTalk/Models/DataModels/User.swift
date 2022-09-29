//
//  User.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 10/09/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable, Equatable{
    var id: String = ""
    var pushId: String = ""
    var imageLink: String = ""
    var name, email, status: String
    
    static func == (lhs: User, rhs: User) -> Bool{
        lhs.id == rhs.id
    }
}

struct UserAuth{
    var email: String
    var password: String
    var name: String?
//    var image: UIImage?
}


