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
        let saver = SaveOperation(name: name, text: text, avatar: avatar, color: color)
        saver.completionBlock = {
            DispatchQueue.main.async {
                complete(saver.err)
            }
        }
        
        operations.addOperation(saver)
    }
    
    func readInfo(complete: @escaping (_ name: String, _ text: String, _ avatar: UIImage?, _ color: UIColor?) -> Void) {
        
        let reader = ReadOperation()
        reader.completionBlock = {
            DispatchQueue.main.async {
                complete(reader.textName, reader.text, reader.image, reader.color)
            }
        }
        
        operations.addOperation(reader)
    }
    
    init() {
        operations.qualityOfService = .utility
    }
}


class SaveOperation : Operation {
    
    let Name = "Name"
    let Text =  "Text"
    let Color = "Color"
    
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
            dict[Name] = nameUser
            dict[Text] = text
            dict[Color] = color?.toHexString()
            
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

class ReadOperation: Operation {
    
    let Name = "Name"
    let Text =  "Text"
    let Color = "Color"
    
    var textName = ""
    var text = ""
    var color: UIColor?
    var image: UIImage?
    
    override func main() {
            if let plist = Plist(name: "data") {
                let dict = plist.getValuesInPlistFile()
                textName = dict?[Name] as! String
                text = dict?[Text] as! String
                let col = dict?[self.Color] as? Int
                
                if let r = col {
                    print("Read: ", r)
                    color = UIColor(rgb: r)
                }
            }
            
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let filePath = documentsURL.appendingPathComponent("avatar.png").path
        
            if FileManager.default.fileExists(atPath: filePath) {
                image = UIImage(contentsOfFile: filePath)
            }
    }

}


//extension UIColor {
//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }
//    
//    convenience init(rgb: Int) {
//        self.init(
//            red: (rgb & 0xFF0000) >> 16,
//            green: (rgb  & 0x00FF00) >> 8,
//            blue: rgb & 0x0000FF
//        )
//    }
//}


extension UIColor {
//    convenience init(rgb hexString:String) {
//        let scanner  = Scanner(string: hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
//        
//        if (hexString.hasPrefix("#")) {
//            scanner.scanLocation = 1
//        }
//        
//        var color:UInt32 = 0
//        scanner.scanHexInt32(&color)
//        
//        let mask = 0x000000FF
//        let r = Int(color >> 16) & mask
//        let g = Int(color >> 8) & mask
//        let b = Int(color) & mask
//        
//        let red   = CGFloat(r) / 255.0
//        let green = CGFloat(g) / 255.0
//        let blue  = CGFloat(b) / 255.0
//        
//        self.init(red:red, green:green, blue:blue, alpha:1)
//    }
//    
    func toHexString() -> Int {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return rgb
    }
}

extension UIColor {
    convenience init(rgb hex: Int) {
        self.init(hex: hex, a: 1.0)
    }
    
    convenience init(hex: Int, a: CGFloat) {
        self.init(r: (hex >> 16) & 0xff, g: (hex >> 8) & 0xff, b: hex & 0xff, a: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    
    convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
}


