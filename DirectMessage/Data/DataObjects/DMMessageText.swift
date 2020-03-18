//
//  DMMessageText.swift
//  DirectMessage
//
//  Created by Seraph on 2020/3/15.
//  Copyright © 2020 Paradise. All rights reserved.
//

import UIKit

class DMMessageText {
    
    enum Constants {
        static let currentUserId = "me"
    }
    
    var text: String
    var senderId: String
    var sentTime: Date
    var isMine: Bool {
        self.senderId == Constants.currentUserId
    }
    
    init(with text: String, senderId: String = Constants.currentUserId, sentTime: Date = Date()) {
        self.text = text
        self.senderId = senderId
        self.sentTime = sentTime
    }
}
