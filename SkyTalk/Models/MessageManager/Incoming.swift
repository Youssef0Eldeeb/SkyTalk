//
//  Incoming.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 30/09/2022.
//

import Foundation
import MessageKit

class Incoming {
    var messageViewController: MessagesViewController
    
    init(messageViewController: MessagesViewController) {
        self.messageViewController = messageViewController
    }
    
    func createMKMessage(localMessage: LocalMessage) -> MkMessage{
        let mkMessage = MkMessage(message: localMessage)
        return mkMessage
    }
}
