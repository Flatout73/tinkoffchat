//
//  ProfileModel.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 23.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

protocol IProfileModel {
    func read(complete: @escaping (String, String, UIImage?, UIColor?) -> ())
    func save(name:String, text: String, avatar: UIImage, color: UIColor?, complete: @escaping (String?) -> Void)
}

class ProfileModel: IProfileModel {
    
    var storageManger: ISaver?
    
    func save(name: String, text: String, avatar: UIImage, color: UIColor?, complete: @escaping (String?) -> Void) {
        storageManger?.saveAppUser(name: name, text: text, avatar: avatar, color: nil, complete: complete)
    }

    func read(complete: @escaping (String, String, UIImage?, UIColor?) -> ()) {
        storageManger?.readAppUser(complete: complete)
    }
    
}
