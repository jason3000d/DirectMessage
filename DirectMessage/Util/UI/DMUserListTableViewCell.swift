//
//  DMUserListTableViewCell.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/11.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

class DMUserListTableViewCell: UITableViewCell {
    
    enum Constants {
        static let cellIdentifier = "DMUserListTableViewCell"
        static let rowHeight: CGFloat = 64
    }

    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarView.accessibilityIdentifier = "avatarView"
        self.userNameLabel.accessibilityIdentifier = "userNameLabel"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarView.image = nil
        self.userNameLabel.text = nil
    }
    
}
