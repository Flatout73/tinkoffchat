//
//  CommunicatorDelegate.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 11.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

protocol ICommunicatorSender : class {
    func send(message: String, to userID: String, completionHandler: ((String?, Error?) -> ())?)
}

class CommunicatorManager : ICommunicatorDelegate, ICommunicatorSender {
    
    let multipeer = MultipeerCommunicator()
    
    var conversationController: IConversationsModel? = nil
    var messagesController: IMessagesModel?
    
    init() {
        multipeer.delegate = self
    }
    
    func add(controller: IConversationsModel) {
        conversationController = controller
    }
    
    func add(messagesController: IMessagesModel) {
        self.messagesController = messagesController
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String, messageID: String) {
        if (messagesController != nil){
            messagesController?.didReceiveMessage(text: text)
        }
        conversationController?.didRecieveMessage(text: text, userID: fromUser, messageID: messageID)
    }

    func failedToStartAdvertising(error: Error) {
        let alert = UIAlertView(title:"Не удалось запустить Advertising", message: error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
        
        alert.show()
    }

    func failedToStartBrowsingForUsers(error: Error) {
        let alert = UIAlertView(title:"Не удалось запустить Browsing клиентов", message:error.localizedDescription, delegate:nil, cancelButtonTitle:"OK")
        
        alert.show()
    }

    func didLostUser(userID: String) {
        conversationController?.deleteUser(peerID: userID)
    }

    func didFoundUser(userID: String, userName: String?) {
        if let u = userName{
            conversationController?.addUser(name: u, ID:userID)
        } else {
            conversationController?.addUser(name: "No name", ID: userID)
        }
    }
    
    func send(message: String, to userID: String, completionHandler: ((String?, Error?) -> ())?) {
        multipeer.sendMessage(string: message, to: userID, completionHandler: completionHandler)
    }

    
}
