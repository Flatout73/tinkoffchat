//
//  DataBaseOldiOS.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 30.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataBaseOldiOS: IDataBase {
    private var storeURL : URL {
        get {
            let documentsDirURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsDirURL.appendingPathComponent("store.sqlite")
            
            return url
        }
    }
    
    private let managedObjectModelName = "tink_chat"
    private var _managedObjectModel: NSManagedObjectModel?
    private var managedObjectModel: NSManagedObjectModel? {
        get {
            if(_managedObjectModel == nil) {
                guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension:"momd")
                    else {
                        print("Empty model url")
                        return nil
                }
                _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
            }
            return _managedObjectModel
        }
    }
    
    private var _persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var persistentStoreCoordinator: NSPersistentStoreCoordinator? {
        get {
            if(_persistentStoreCoordinator == nil) {
                guard let model = self.managedObjectModel else {
                    print("Empty managed object model")
                    return nil
                }
                _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                
                do {
                    try _persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                } catch{
                    print(error)
                }
                
            }
            return _persistentStoreCoordinator
        }
    }
    
    private var _masterContext: NSManagedObjectContext?
    private var masterContext: NSManagedObjectContext? {
        get {
            if _masterContext == nil {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                
                guard let persistentStoreCoordinator = self.persistentStoreCoordinator else {
                    print("Empty persistant store coordinator!")
                    return nil
                }
                
                context.persistentStoreCoordinator = persistentStoreCoordinator
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _masterContext = context
            }
            return _masterContext
        }
    }
    
    private var _mainContext: NSManagedObjectContext?
    public var mainContext: NSManagedObjectContext? {
        get {
            if(_mainContext == nil) {
                let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                guard let parentContext = self.masterContext else {
                    print("No master context")
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _mainContext = context
            }
            return _mainContext
        }
    }
    
    private var _saveContext: NSManagedObjectContext?
    public var saveContext: NSManagedObjectContext? {
        get {
            if(_saveContext == nil) {
                let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                guard let parentContext = self.mainContext else {
                    print("No main context")
                    return nil
                }
                
                context.parent = parentContext
                context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
                context.undoManager = nil
                _saveContext = context
            }
            return _saveContext
        }
    }
    
    
    public func performSave(context: NSManagedObjectContext, completionHandler: ((String?)->Void)?) {
        if(context.hasChanges) {
            context.perform { [weak self] in
                do {
                    try context.save()
                    print("Контекст \(context.description) сохранен")
                }
                catch {
                    print("Context save error: \(error)")
                    completionHandler?(error.localizedDescription)
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?(nil)
                }
            }
        }
        else {
            completionHandler?(nil)
        }
    }
    
}
