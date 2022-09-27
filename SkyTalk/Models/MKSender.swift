//
//  MKSender.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 27/09/2022.
//

import Foundation
import MessageKit

struct MKSender: SenderType, Equatable{
    var senderId: String
    var displayName: String
}
