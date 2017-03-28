//
//  BubbleMessageCell.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 28.03.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration : class {
    var textM: String? {get set}
}

class BubbleMessageCell: UITableViewCell, MessageCellConfiguration {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!

    
    var color:UIColor = UIColor.gray
    
    var textM: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.layer.borderWidth = 5.0
        //self.layer.cornerRadius = 10
        
        //messageLabel.frame.width = self.frame.width * 3/4
        
        //messageLabel.text = "asdfsdfasdfdsafsadfsdafasdfsadfsadfsdfsadfsafsafsdafsdfsdafasdf"
        
        messageView.layer.cornerRadius = 10
        messageView.layer.borderWidth = 2.0
        messageView.layer.borderColor = UIColor.white.cgColor
        //messageView.frame = CGRect(x: 8, y: 8, width: messageLabel.frame.width + 16, height: messageLabel.frame.height + 8)
        
        //messageLabel.frame = CGRect(x: messageView.frame.minX, y: messageView.frame.minY - 4, width: messageLabel.frame.width, height: messageLabel.frame.height)
        
//        let horizontalConstraint = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: messageView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
//        let verticalConstraint = NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: messageView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
//        
//        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
        //self.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func draw(_ rect: CGRect) {
//        let rounding:CGFloat = rect.width * 0.02
//        
//        let bubbleFrame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height * 2 / 3)
//        
//        let bubblePath = UIBezierPath(roundedRect: bubbleFrame, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: rounding, height: rounding))
//        
//        color.setStroke()
//        color.setFill()
//        bubblePath.stroke()
//        bubblePath.fill()
//        
//        let context = UIGraphicsGetCurrentContext()
//      
//        if let bitmap = context{
//            bitmap.beginPath()
//            bitmap.move(to: CGPoint(x: bubbleFrame.minX + bubbleFrame.width * 1/3, y: bubbleFrame.maxY))
//            bitmap.addArc(tangent1End: CGPoint(x: rect.maxX * 1/3, y:rect.maxY), tangent2End: CGPoint(x:bubbleFrame.maxX, y: bubbleFrame.maxY), radius: rounding)
//            bitmap.addLine(to: CGPoint(x: bubbleFrame.minX + bubbleFrame.width * 2/3, y: bubbleFrame.maxY))
//            bitmap.closePath()
//            
//            bitmap.setFillColor(color.cgColor)
//            bitmap.fillPath()
//        }
    }

}
