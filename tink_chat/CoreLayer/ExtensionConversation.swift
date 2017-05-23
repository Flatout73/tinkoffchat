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
    static func insertConversation(in context: NSManagedObjectContext, conversationId: String, isOnline: Bool)->Conversation? {
        
        if let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation {
            conversation.conversationID = conversationId
            conversation.isOnline = isOnline
            
            conversation.lastMessage = nil
            
            return conversation
        }
        
        return nil
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
