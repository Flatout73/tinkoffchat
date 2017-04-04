//
//  GCDataManager.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 04.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import UIKit

class GCDataManager {
    
    var err: String? = nil
    
    func save(name:String, text: String, avatar: UIImage, color: UIColor, complete: @escaping (String?) -> Void) {
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let plist = Plist(name: "data") {
                let dict = plist.getMutablePlistFile()!
                dict["Name"] = name
                dict["Text"] = text
                dict["Color"] = color.hashValue
                
                do {
                    try plist.addValuesToPlistFile(dictionary: dict)
                } catch {
                    print(error)
                    self.err = error.localizedDescription
                }
                //print(plist.getValuesInPlistFile()!)
            }
            else {
                print("Unable to get Plist")
                self.err = "Unable to get Plist"
            }
            
            do {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsURL.appendingPathComponent("avatar.png")
                if let pngImageData = UIImagePNGRepresentation(avatar) {
                    try pngImageData.write(to: fileURL, options: .atomic)
                }
            } catch {
                print(error)
                self.err = error.localizedDescription
            }
            DispatchQueue.main.async {
                complete(self.err)
            }
        }
    }
    
}
