//
//  CellData.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 28.03.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import UIKit

class CellData: ConversationCellConfiguration {
    var name: String?
    var message: String?
    var date: Date?
    var hasUnreadMessages: Bool
    var online: Bool
    
    init(n: String, m: String?, d: Date, h: Bool, o: Bool) {
        name = n
        message = m
        date = d
        hasUnreadMessages = h
        online = o
    }
}
