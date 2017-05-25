//
//  StorageManager.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 28.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class StoreManager: ISaver, ISaverConversation {
    
    //@available(iOS 10.0, *)
    //lazy var dataBase = DataBase()
    
    lazy var dataBaseOld = DataBaseOldiOS()
    
    var orderIndex = 0
    
    func saveAppUser(name: String, text: String, avatar: UIImage, color: UIColor?, complete: @escaping (String?) -> Void) {
        
//        if #available(iOS 10.0, *) {
//            let fetchRequest:NSFetchRequest<AppUser> = AppUser.fetchRequest()
//            do{
//                
//                let result = try dataBase.persistentContainer.viewContext.fetch(fetchRequest)
//                
//                if let appUser = (result as [AppUser]).first {
//                    appUser.name = name
//                    appUser.info = text
//                    appUser.avatar = UIImagePNGRepresentation(avatar) as NSData?
//                } else {
//                    if let currentUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: dataBase.persistentContainer.viewContext) as? AppUser {
//                        currentUser.name = name
//                        currentUser.info = text
//                        currentUser.avatar = UIImagePNGRepresentation(avatar) as NSData?
//                    }
//                }
//                complete(nil)
//            } catch{
//                print(error)
//                complete(error.localizedDescription)
//            }
//            
//            dataBase.saveContext()
//        } else {
            _ = AppUser.findOrInsertAppUser(in: dataBaseOld.saveContext!, name: name, info: text, avatar: avatar)
            dataBaseOld.performSave(context: dataBaseOld.saveContext!, completionHandler: complete)
//        }
    }
    func readAppUser(complete: @escaping (String, String, UIImage?, UIColor?) -> Void) {
        
//        if #available(iOS 10.0, *) {
//            let fetchRequest:NSFetchRequest<AppUser> = AppUser.fetchRequest()
//            
//            do{
//                let result = try dataBase.persistentContainer.viewContext.fetch(fetchRequest)
//                if let appUser = (result as [AppUser]).first {
//                    if let avatar =  appUser.avatar as Data? {
//                        complete(appUser.name!, appUser.info!, UIImage(data: avatar), nil)
//                    }
//                } else {
//                    complete("", "", nil, nil)
//                }
//            } catch{
//                print(error)
//            }
//        } else {
        
            if let appUser = AppUser.findUser(in: dataBaseOld.mainContext!) {
                if let avatar = appUser.avatar as Data? {
                    complete(appUser.currentUser!.name!, appUser.info!, UIImage(data: avatar), nil)
                }
            } else {
                complete("", "", nil, nil)
            }
            
//        }
    }
    
    
    func foundUser(name: String, ID: String) {
        _ = User.findOrInsertUser(in: dataBaseOld.saveContext!, peerID: ID, name: name)
        //_ = Conversation.insertConversation(in: dataBaseOld.saveContext!, conversationId: ID, isOnline: true)
        dataBaseOld.performSave(context: dataBaseOld.saveContext!){ err in
            if let e = err {
                print("Все плохо: ", e)
                
            } else {
                print("User saved", name)
            }
        }
    }
    
    func lostUser(peerID: String) {
        let findRequest: NSFetchRequest<User> = dataBaseOld.mainContext?.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "UserWithId", substitutionVariables: ["USERID": peerID]) as! NSFetchRequest<User>
        findRequest.resultType = .managedObjectResultType
        do{
            let results = try dataBaseOld.saveContext?.fetch(findRequest)
            //assert((results as! [NSManagedObject]).count < 2, "Multiple users found!")
            
            let user = results?.first
            user?.isOnline = false
            if let conversations = user?.conversations as? Set<Conversation> {
                for conversation in conversations {
                    conversation.isOnline = false
                    break
                }
            }
            //(user?.conversations?.array.first as? Conversation)?.isOnline = false
            dataBaseOld.performSave(context: dataBaseOld.saveContext!, completionHandler: nil)
        } catch {
            print(error.localizedDescription)
        }
        
        
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String, messageID: String) {
        _ = Message.insertMessage(in: dataBaseOld.saveContext!, messageId: messageID, orderedIndex: orderIndex, date: Date(), text: text, toUser: toUser, fromUser: fromUser)
        
        dataBaseOld.performSave(context: dataBaseOld.saveContext!) { (err) in
            print("Сообщение сохранено")
        }
        
        orderIndex += 1
    }
    
    func didSendMessage(text: String, fromUser: String, toUser: String, messageID: String) {
        _ = Message.insertMessage(in: dataBaseOld.saveContext!, messageId: messageID, orderedIndex: orderIndex, date: Date(), text: text,  toUser: toUser, fromUser: fromUser)
        
        dataBaseOld.performSave(context: dataBaseOld.saveContext!) { (err) in
            print("Сообщение сохранено")
        }
        
        orderIndex += 1
    }
    
    func getFRCForMessagesWith(conversationID: String) -> NSFetchedResultsController<Message> {
        let fetchRequest = dataBaseOld.mainContext!.persistentStoreCoordinator?.managedObjectModel.fetchRequestFromTemplate(withName: "MessagesWithConvId", substitutionVariables: ["ID":conversationID]) as! NSFetchRequest<Message>
        
        fetchRequest.fetchBatchSize = 10
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return NSFetchedResultsController<Message>(fetchRequest: fetchRequest, managedObjectContext: dataBaseOld.mainContext!, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func getFRCForConversations(tableView: UITableView) -> NSFetchedResultsController<Conversation> {
//        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
//        
//        let sortDescriptors = NSSortDescriptor(key: "conversationID", ascending: true)
//        
//        fetchRequest.sortDescriptors = [sortDescriptors]
//        
//        return NSFetchedResultsController<Conversation>.init(fetchRequest: fetchRequest, managedObjectContext: dataBaseOld.mainContext!, sectionNameKeyPath: #keyPath(Conversation.isOnline), cacheName: nil)
        //let dataProvider = ConversationDataProvider(tableView: tableView)
        
        var fetchedResultsController: NSFetchedResultsController<Conversation>?
        
        let fetchRequest: NSFetchRequest<Conversation> = Conversation.fetchRequest()
        
        let sortDescriptors = NSSortDescriptor(key: "conversationID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptors]
        
        dataBaseOld.mainContext?.stalenessInterval = 0
        
        fetchedResultsController = NSFetchedResultsController<Conversation>(fetchRequest:
            fetchRequest, managedObjectContext: dataBaseOld.mainContext!, sectionNameKeyPath: #keyPath(Conversation.isOnline), cacheName: nil)
        
        //fetchedResultsController?.delegate = dataProvider
        return fetchedResultsController!
        
    }
    
    func getUserOnlineBy(peerID: String) -> Bool {
        let user = User.findUser(in: dataBaseOld.mainContext!, peerID: peerID)
        
        //если зашли в диалог прочитали все сообщения
        let conversation = Conversation.findConversation(in: dataBaseOld.saveContext!, conversationId: peerID)
        conversation?.unreadMessages = nil
        return user!.isOnline
    }
    
    func makeAllOffline() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let result = try dataBaseOld.saveContext?.fetch(fetchRequest)
            if let result = result{
                for user in result {
                    user.isOnline = false
                    user.conversations?.forEach { (conversation) in
                        (conversation as? Conversation)?.isOnline = false
                    }
                }
            }
        } catch {
            print(error)
        }
        
        dataBaseOld.performSave(context: dataBaseOld.saveContext!, completionHandler: nil)
    
    }
}
