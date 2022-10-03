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
        updateMicButtonStatus(show: text == "")
        
        if text != ""{
            startTypingIndicator()
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        send(text: text, photo: nil, video: nil, audio: nil, location: nil)
        
        messagesCollectionView.scrollToLastItem()
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
    
}
