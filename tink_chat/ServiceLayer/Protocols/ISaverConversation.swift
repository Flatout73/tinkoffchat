//
//  ISaverUsers.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 14.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import CoreData

protocol ISaverConversation: class {
    func foundUser(name: String, ID: String)
    
    func lostUser(peerID: String)
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String, messageID: String)
    
    func didSendMessage(text: String, fromUser: String, toUser: String, messageID: String)
    
    func getFRCForMessagesWith(conversationID: String) -> NSFetchedResultsController<Message>
    
    func getUserOnlineBy(peerID: String) -> Bool
}
