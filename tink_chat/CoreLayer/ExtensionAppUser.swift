//
//  ExtensionAppUser.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 14.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import CoreData
import UIKit


extension AppUser {
    
    //не забудь, что id взят из класса multepeer, мб стоит придумать что-нибудь универсальное, вроде плиста или читать из бд
    private static func insertAppUser(in context: NSManagedObjectContext, name: String, info: String, avatar: UIImage) ->AppUser? {
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser {
            let user = User.findOrInsertUser(in: context, peerID: UIDevice.current.name, name: name)
            appUser.currentUser = user
            appUser.info = info
            appUser.avatar = UIImagePNGRepresentation(avatar) as NSData?
            
            return appUser
        }
        return nil
    }
    
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext, name: String, info: String, avatar: UIImage) -> AppUser? {
        //        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
        //            print("Model is not avaliable in context")
        //            return nil
        //        }
        
        var appUser: AppUser?
        
        appUser = AppUser.findUser(in: context)
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context, name: name, info: info, avatar: avatar)
        } else {
            appUser?.currentUser?.name = name
            appUser?.info = info
            appUser?.avatar = UIImagePNGRepresentation(avatar) as NSData?
        }
        return appUser
    }
    
    static func findUser(in context: NSManagedObjectContext) -> AppUser? {
        var appUser: AppUser?
        let fetchRequest:NSFetchRequest<AppUser> = AppUser.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple users found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error)")
        }
        
        return appUser
    }
}
