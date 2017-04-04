
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
    
    let Name = "Name"
    let Text =  "Text"
    let Color = "Color"
    
    func save(name:String, text: String, avatar: UIImage, color: UIColor, complete: @escaping (String?) -> Void) {
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let plist = Plist(name: "data") {
                let dict = plist.getMutablePlistFile()!
                dict[self.Name] = name
                dict[self.Text] = text
                dict[self.Color] = color.toHexString()
                
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
    
    func read(complete: @escaping (_ name: String, _ text: String, _ avatar: UIImage, _ color: UIColor?) -> Void) {
        
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            
            var textName = ""
            var text = ""
            var color: UIColor?
            if let plist = Plist(name: "data") {
                let dict = plist.getValuesInPlistFile()
                textName = dict?[self.Name] as! String
                text = dict?[self.Text] as! String
                let col = dict?[self.Color] as? Int
                if let r = col {
                    color = UIColor(rgb: r)
                }
            }
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent("avatar.png").path
            
            var image: UIImage?
            if FileManager.default.fileExists(atPath: filePath) {
                image = UIImage(contentsOfFile: filePath)
            }
            
            DispatchQueue.main.async {
                complete(textName, text, image!, color)
            }
        }
    }
    
}
