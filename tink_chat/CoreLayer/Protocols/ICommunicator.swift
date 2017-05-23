//
//  ICommunicator.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 23.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation

protocol ICommunicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: String?, _ error: Error?) -> ())?)
    weak var delegate: ICommunicatorDelegate? {get set}
    var online: Bool {get set}
}
