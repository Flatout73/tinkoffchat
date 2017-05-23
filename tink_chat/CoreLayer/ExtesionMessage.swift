//
//  ExtesionMessage.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 14.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import CoreData

extension Message{
    static func insertMessage(in context: NSManagedObjectContext,  messageId: String, orderedIndex: Int, date: Date, text: String, toUser: String, fromUser: String)->Message? {
        
        if let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message {
            message.messageId = messageId
            message.orderIndex = Int16(orderedIndex)
            message.date = date as NSDate
            message.text = text
          
            var otherUser: User
            if(fromUser != "me") {
                //сделать нормально
            
                message.sender = User.findUser(in: context, peerID: fromUser)
                //message.receiver = AppUser.findUser(in: context)?.currentUser
                message.receiver = nil
                
                otherUser = message.sender!
                
            } else {
                //message.sender = AppUser.findUser(in: context)?.currentUser
                message.receiver = User.findUser(in: context, peerID: toUser)
                
                message.sender = nil
                
                otherUser = message.receiver!
            }
            
            let conversation = Conversation.findConversation(in: context, conversationId: otherUser.userId!)
            message.unreadInConversation = conversation
            message.conversation = conversation
            message.lastMessageInConversation = conversation
            
            return message
        }
        
        return nil
    }
    
    
}
