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


class StoreManager: ISaver {
    
    @available(iOS 10.0, *)
    lazy var dataBase = DataBase()
    lazy var dataBaseOld = DataBaseOldiOS()
    
    func save(name: String, text: String, avatar: UIImage, color: UIColor?, complete: @escaping (String?) -> Void) {
        
        if #available(iOS 10.0, *) {
            let fetchRequest:NSFetchRequest<AppUser> = AppUser.fetchRequest()
            do{
                
                let result = try dataBase.persistentContainer.viewContext.fetch(fetchRequest)
                
                if let appUser = (result as [AppUser]).first {
                    appUser.name = name
                    appUser.info = text
                    appUser.avatar = UIImagePNGRepresentation(avatar) as NSData?
                } else {
                    if let currentUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: dataBase.persistentContainer.viewContext) as? AppUser {
                        currentUser.name = name
                        currentUser.info = text
                        currentUser.avatar = UIImagePNGRepresentation(avatar) as NSData?
                    }
                }
                complete(nil)
            } catch{
                print(error)
                complete(error.localizedDescription)
            }
            
            dataBase.saveContext()
        } else {
            _ = AppUser.findOrInsertAppUser(in: dataBaseOld.saveContext!, name: name, info: text, avatar: avatar)
            dataBaseOld.performSave(context: dataBaseOld.saveContext!, completionHandler: complete)
        }
    }
    func read(complete: @escaping (String, String, UIImage?, UIColor?) -> Void) {
        
        if #available(iOS 10.0, *) {
            let fetchRequest:NSFetchRequest<AppUser> = AppUser.fetchRequest()
            
            do{
                let result = try dataBase.persistentContainer.viewContext.fetch(fetchRequest)
                if let appUser = (result as [AppUser]).first {
                    if let avatar =  appUser.avatar as Data? {
                        complete(appUser.name!, appUser.info!, UIImage(data: avatar), nil)
                    }
                } else {
                    complete("", "", nil, nil)
                }
            } catch{
                print(error)
            }
        } else {
            if let appUser = AppUser.findUser(in: dataBaseOld.mainContext!) {
                if let avatar = appUser.avatar as Data? {
                    complete(appUser.name!, appUser.info!, UIImage(data: avatar), nil)
                }
            } else {
                complete("", "", nil, nil)
            }
            
        }
    }
}
