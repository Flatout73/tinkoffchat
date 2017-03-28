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
        messageView.layer.cornerRadius = 10
        messageView.layer.borderWidth = 2.0
        messageView.layer.borderColor = UIColor.white.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
