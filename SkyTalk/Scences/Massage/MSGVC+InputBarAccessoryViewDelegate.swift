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
        print("sending----", text)
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
    
}
