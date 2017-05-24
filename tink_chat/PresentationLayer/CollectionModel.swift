//
//  CollectionModel.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 24.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

class CollectionModel {
    
    var imageManger = ImageManager(requestSender: RequestSender())
    
    func getPictures(completionHandler: @escaping ([ApiImage]?, String?)->Void) {
        imageManger.loadImages(completionHandler: completionHandler)
    }
}
