//
//  ExtensionUser.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 14.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import CoreData

extension User{
    private static func insertUser(in context: NSManagedObjectContext,  userId: String, isOnline: Bool, name: String)->User? {
        
        if let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
            user.userId = userId
            user.isOnline = isOnline
            user.name = name
            
            let converstion = Conversation.insertConversation(in: context, conversationId: userId, isOnline: isOnline)
            
            user.addToConversations(converstion!)
            
            return user
        }
        
        return nil
    }
    
    static func findOrInsertUser(in context: NSManagedObjectContext, peerID: String, name: String) -> User? {
        let findRequest: NSFetchRequest<User> = context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "UserWithId", substitutionVariables: ["USERID": peerID]) as! NSFetchRequest<User>
        findRequest.resultType = .managedObjectResultType
        do{
            let results = try context.fetch(findRequest)
            
            if let user = results.first {
                user.isOnline = true
                if let conversations = user.conversations as? Set<Conversation> {
                    for conversation in conversations {
                        conversation.isOnline = true
                    }
                }
                //(user.conversations?.array.first as? Conversation)?.isOnline = true
                user.name = name
                return user
            } else {
                return insertUser(in: context, userId: peerID, isOnline: true, name: name)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        return nil
        
    }
    
    static func findUser(in context: NSManagedObjectContext, peerID: String) -> User? {
        let findRequest: NSFetchRequest<User> = context.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "UserWithId", substitutionVariables: ["USERID": peerID]) as! NSFetchRequest<User>
        do {
            let users = try context.fetch(findRequest)
            
            return users.first
            
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
    
}
