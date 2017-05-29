//
//  ExtensionConversation.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 14.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import CoreData


//id у конверсейшена совпадает с id юзера
extension Conversation{
    private static func insertConversation(in context: NSManagedObjectContext, conversationId: String, isOnline: Bool, name: String)->Conversation? {
        
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation {
            conversation.conversationID = conversationId
            conversation.isOnline = isOnline
            
            conversation.lastMessage = nil
            
            let user = User.insertUser(in: context, userId: conversationId, isOnline: true, name: name)
            
            conversation.addToParticipants(user!)
            
            return conversation
        }
        
        return nil
    }
    
    static func findOrInsertConversation(in context: NSManagedObjectContext, ID: String, name: String) -> Conversation? {
        
        
            if let conversation = findConversation(in: context, conversationId: ID) {
                conversation.isOnline = true
                if let users = conversation.participants as? Set<User> {
                    for user in users {
                        user.isOnline = true
                        user.name = name
                    }
                }
                //(user.conversations?.array.first as? Conversation)?.isOnline = true
                
                return conversation
            } else {
                return insertConversation(in: context, conversationId: ID, isOnline: true, name: name)
            }
        
    }
    
    static func findConversation(in context: NSManagedObjectContext, conversationId: String) ->Conversation? {
        let findRequest: NSFetchRequest<Conversation> = context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "ConversationWithId", substitutionVariables: ["CONVERSATIONID": conversationId]) as! NSFetchRequest<Conversation>
        do{
            let results = try context.fetch(findRequest)
            
            return results.first
        }catch{
            print(error.localizedDescription)
        }
        
        return nil
    }
    

}
