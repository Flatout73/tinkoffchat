//
//  MessagesModel.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 23.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import CoreData

protocol IMessagesModel: class {
    weak var delegate: IMessagesModelDelegate? {get set}
    func didReceiveMessage(text: String)
    func enableButton() -> Bool
}

class MessagesModel: IMessagesModel {
    weak var delegate: IMessagesModelDelegate?

    weak var manager: ICommunicatorSender?
    
    weak var storage: ISaverConversation?
    
    var frc: NSFetchedResultsController<Message>?
    
    var peerID: String
    
    init(peerID: String) {
        self.peerID = peerID
    }
    
    var k = 11
    func send(message: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        storage?.didSendMessage(text: message, fromUser: "me", toUser: userID, messageID: String(k))
        k += 1
        manager?.send(message: message, to: userID) { (messageId, error) in
            if let id = messageId {
                self.storage?.didSendMessage(text: message, fromUser: "me", toUser: userID, messageID: id)
                completionHandler?(true, error)
            } else {
                completionHandler?(false, error)
            }
        }
    
    }
    
    func didReceiveMessage(text: String) {
        //delegate?.didReceiveMessage(text: text)
    }
    
    func enableButton() -> Bool {
        return storage!.getUserOnlineBy(peerID: peerID)
    }
}
