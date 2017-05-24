//
//  ImageParser.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 24.05.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import Foundation
import UIKit

struct ApiImage {
    var imageURL: String
}

class ImageParser: Parser<[ApiImage]> {
    override func Parse(data: Data) -> [ApiImage]? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let imageArray = json["hits"] as? [[String : Any]] else {
                return nil
            }
            
            var images: [ApiImage] = []
            
            for appObject in imageArray {
                guard let urlString = appObject["webformatURL"] as? String else {
                    continue
                }
                images.append(ApiImage(imageURL: urlString))
//                if let url = URL(string: urlString) {
//                    let imageData = try Data(contentsOf: url)
//                    if let image = UIImage(data: imageData){
//                        
//                    }
//                }
            }
            
            return images
            
        } catch  {
            print("error trying to convert data to JSON", error)
            return nil
        }
    }
}
