//
//  MSGVC+InputBarAccessoryViewDelegate.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 27/09/2022.
//

import Foundation
import MessageKit
import InputBarAccessoryView


extension MassageViewController: InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        print(text)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        send(text: text, photo: nil, video: nil, audio: nil, location: nil)
        
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
    
}
