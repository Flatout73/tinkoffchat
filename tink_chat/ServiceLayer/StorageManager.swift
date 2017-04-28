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

@available(iOS 10.0, *)
class StoreManager: ISaver {
    let dataBase = DataBase()
    
    func save(name: String, text: String, avatar: UIImage, color: UIColor?, complete: @escaping (String?) -> Void) {
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
    }
    func read(complete: @escaping (String, String, UIImage?, UIColor?) -> Void) {
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
    }
}
