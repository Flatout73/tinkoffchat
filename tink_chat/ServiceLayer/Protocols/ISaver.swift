//
//  ISaver.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 28.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

protocol ISaver {
    func save(name: String, text: String, avatar: UIImage, color: UIColor?, complete: @escaping (String?) -> Void)
    func read(complete: @escaping (_ name: String, _ text: String, _ avatar: UIImage?, _ color: UIColor?) -> Void)
}
