//
//  OperationDataManager.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 04.04.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import UIKit

class OperationDataManager {
    
    let operations = OperationQueue()
    
    
    func saveInfo(name:String, text: String, avatar: UIImage, color: UIColor, complete: @escaping (String?) -> Void){
        let saver = saveOperation(name: name, text: text, avatar: avatar, color: color)
        saver.completionBlock = {
            DispatchQueue.main.async {
                complete(saver.err)
            }
        }
        
        operations.addOperation(saver)
    }
    
    init() {
        operations.qualityOfService = .utility
    }
}


class saveOperation : Operation {
    
    var err: String? = nil
    
    var nameUser: String?
    var text: String?
    var avatar: UIImage?
    var color: UIColor?
    
    init(name:String, text: String, avatar: UIImage, color: UIColor) {
        self.nameUser = name
        self.text = text
        self.avatar = avatar
        self.color = color
    }
    
    override func main() {
        if let plist = Plist(name: "data") {
            let dict = plist.getMutablePlistFile()!
            dict["Name"] = nameUser
            dict["Text"] = text
            dict["Color"] = color?.hashValue
//            dict["Blue"] = color?.ciColor.blue
//            dict["Green"] = color?.ciColor.green
            
            do {
                try plist.addValuesToPlistFile(dictionary: dict)
            } catch {
                print(error)
                err = error.localizedDescription
            }
            //print(plist.getValuesInPlistFile()!)
        }
        else {
            print("Unable to get Plist")
            err = "Unable to get Plist"
        }
        
        do {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("avatar.png")
            if let pngImageData = UIImagePNGRepresentation(avatar!) {
                try pngImageData.write(to: fileURL, options: .atomic)
            }
        } catch {
            print(error)
            err = error.localizedDescription
        }
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
