//
//  IConversationModel.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 23.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation

protocol IConversationsModelDelegate: class {
    
    
    func didRecieveMessage(text: String, userID: String)
    func deleteUser(peerID: String)
    func addUser(name: String, ID: String, message: String?, date: Date, unread: Bool, online: Bool)
}
