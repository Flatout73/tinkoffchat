//
//  ImageManager.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 24.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

class ImageManager {
    
    let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadImages(completionHandler: @escaping ([ApiImage]?, String?) -> Void) {
        let requestConfig = RequestFactory.ImageApi.loadImage()
        
        requestSender.send(config: requestConfig) { (result: Result<[ApiImage]>) in
            switch result {
            case .Success(let tracks):
                completionHandler(tracks, nil)
                
            case .Fail(let error):
                completionHandler(nil, error)
            }
        }
        
    }
}
