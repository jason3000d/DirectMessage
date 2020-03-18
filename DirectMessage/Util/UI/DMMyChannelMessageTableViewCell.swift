//
//  DMMyChannelMessageTableViewCell.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/14.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

class DMMyChannelMessageTableViewCell: UITableViewCell {
    
    enum Constants {
        static let cellIdentifier = "DMMyChannelMessageTableViewCell"
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

extension DMMyChannelMessageTableViewCell: DMMessageViewProtocol {
    
    func populate(with message: DMMessageText) {
        self.messageLabel.text = message.text
    }
        
}
