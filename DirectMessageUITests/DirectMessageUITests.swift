//
//  DirectMessageUITests.swift
//  DirectMessageUITests
//
//  Created by Seraph on 2020/3/8.
//  Copyright © 2020 Paradise. All rights reserved.
//

import XCTest

class DirectMessageUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        DMTestBuilder(testCase: self).launch()
    }

    func testUserListELements() {
        let firstItem = DMUserListPage(testCase: self).visibleItems()?.first
        firstItem?.checkItemExistence()
    }
    
    func testChatroomSendTextAndResponse() {
        let text = "Hello, World~"
        _ = DMUserListPage(testCase: self).enterChatroom(contains: "@mojombo")
            .on(page: DMInputBoxViewPage.self).sendText(text)
            .on(page: DMMessagePage.self).validateTextMessage(with: text + text)
    }
}
