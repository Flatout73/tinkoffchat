//
//  CommunicatorDelegate.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 11.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

protocol CommunicatorDelegate : class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

class CommunicatorManager : CommunicatorDelegate {
    
    var conversationController: ConversationsListViewController? = nil
    var messagesController: MessagesViewController?
    
    func add(controller: ConversationsListViewController) {
        conversationController = controller
    }
    
    func add(messagesController: MessagesViewController) {
        self.messagesController = messagesController
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        messagesController?.didReceiveMessage(text: text)
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
            conversationController?.addUser(name: u, ID:userID, message: nil)
        } else {
            conversationController?.addUser(name: "pff", ID: userID, message: nil)
        }
    }

    
}
