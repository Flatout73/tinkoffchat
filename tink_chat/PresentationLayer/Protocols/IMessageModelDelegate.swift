//
//  IMessageModelDelegate.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 23.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation

protocol IMessagesModelDelegate: class {
    func didReceiveMessage(text: String)
    func animateEnableButton(enable: Bool)
}
