//
//  ConversationCell.swift
//  tink_chat
//
//  Created by Леонид Лядвейкин on 27.03.17.
//  Copyright © 2017 Tinkoff Bank. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, IConversationCellConfiguration {
    
    internal var hasUnreadMessages: Bool = false
    internal var online: Bool = false
    internal var date: Date?
    internal var message: String?
    internal var name: String?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        nameLabel.text = name
        
        let formatter = DateFormatter()
        if((Date().timeIntervalSince1970 - (date?.timeIntervalSince1970)!) < 86400) {
            formatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormat = "dd MMM"
        }
        
        dateLabel.text = formatter.string(from: date!)
        
        if(online) {
            self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.6, alpha: 0.1)
        } else {
            self.backgroundColor = UIColor.clear
        }
        
        if(hasUnreadMessages) {
            messageLabel.font = UIFont.boldSystemFont(ofSize: messageLabel.font.pointSize)
        }
        
        if let m = message {
            messageLabel.text = m
            messageLabel.font = UIFont.systemFont(ofSize:17)
        } else {
            messageLabel.text = "No messages yet"
            messageLabel.font = UIFont(name: "Optima", size: 17)
            
        }
    }
    
}
