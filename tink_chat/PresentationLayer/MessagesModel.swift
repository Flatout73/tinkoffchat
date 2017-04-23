//
//  MessagesModel.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 23.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation

protocol IMessagesModel: class {
    weak var delegate: IMessagesModelDelegate? {get set}
    func didReceiveMessage(text: String)
}

class MessagesModel: IMessagesModel {
    weak var delegate: IMessagesModelDelegate?

    weak var manager: CommunicatorSender?
    
    func send(message: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        manager?.send(message: message, to: userID, completionHandler: completionHandler)
    }
    
    func didReceiveMessage(text: String) {
        delegate?.didReceiveMessage(text: text)
    }
}
