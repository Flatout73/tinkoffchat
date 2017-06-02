//
//  ConversationsModel.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 23.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol IConversationsModel: class {
    weak var delegate: IConversationsModelDelegate? {get set}
    func didRecieveMessage(text: String, userID: String, messageID: String)
    func deleteUser(peerID: String)
    func addUser(name: String, ID: String)
}

class ConversationsModel: IConversationsModel {
    weak var delegate: IConversationsModelDelegate?
    weak var messagesModel: IMessagesModel?
    
    
    var frc: NSFetchedResultsController<Conversation>

    let manager = CommunicatorManager()
    let store = StoreManager()
    
    var table: UITableView
    
    init(tableView: UITableView, viewController: IConversationsModelDelegate){
        frc = store.getFRCForConversations(tableView: tableView)
        delegate = viewController
        table = tableView
        manager.add(controller: self)
        
        
        
        //addUser(name: "kek", ID: "128")
        //deleteUser(peerID: "128")
        
    }
    
    func addUser(name: String, ID: String) {
        //self.delegate?.addUser(name: name, ID: ID, message: nil, date: Date(), unread: false, online: true)
        store.foundUser(name: name, ID: ID)
        messagesModel?.didFoundUser(userID: ID)
//        DispatchQueue.main.async{
//            self.table.reloadData()
//        }
    }

    func deleteUser(peerID: String) {
        //self.delegate?.deleteUser(peerID: peerID)
        store.lostUser(peerID: peerID)
        messagesModel?.didLostUser(userID: peerID)
//        DispatchQueue.main.async {
//            self.table.reloadData()
//        }
    }

    func didRecieveMessage(text: String, userID: String, messageID: String) {
        //self.delegate?.didRecieveMessage(text: text, userID: userID)
        store.didReceiveMessage(text: text, fromUser: userID, toUser: "me", messageID: messageID)
    }

    func prepare(for segueController: MessagesViewController, peerID: String) {
        let model = MessagesModel(peerID: peerID)
        model.manager = manager
        model.storage = store
        model.delegate = segueController
        model.frc = store.getFRCForMessagesWith(conversationID: peerID)
        
        messagesModel = model
        manager.add(messagesController: model)
        segueController.messagesModel = model
    }
    
    func prepare(for segueController: ProfileViewController) {
        let model = ProfileModel()
        model.storageManger = store
        segueController.model = model
    }
    
}
