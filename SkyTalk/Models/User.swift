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
    var imageLink: Data
    var name, email, status: String
}

struct UserAuth{
    var email: String
    var password: String
    var name: String?
    var image: UIImage?
}

