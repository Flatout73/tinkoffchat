//
//  ConversationsModel.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 23.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation

protocol IConversationsModel: class {
    weak var delegate: IConversationsModelDelegate? {get set}
    func didRecieveMessage(text: String, userID: String)
    func deleteUser(peerID: String)
    func addUser(name: String, ID: String)
}

class ConversationsModel: IConversationsModel {
    weak var delegate: IConversationsModelDelegate?

    let manager = CommunicatorManager()
    
    init(){
        manager.add(controller: self)
    }
    
    func addUser(name: String, ID: String) {
        self.delegate?.addUser(name: name, ID: ID, message: nil, date: Date(), unread: false, online: true)
    }

    func deleteUser(peerID: String) {
        self.delegate?.deleteUser(peerID: peerID)
    }

    func didRecieveMessage(text: String, userID: String) {
        self.delegate?.didRecieveMessage(text: text, userID: userID)
    }

    func prepare(for segueController: MessagesViewController) {
        let model = MessagesModel()
        model.manager = manager
        model.delegate = segueController
        manager.add(messagesController: model)
        segueController.messagesModel = model
    }
    
}
