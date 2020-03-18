//
//  DMUserListPageItem.swift
//  DirectMessageUITests
//
//  Created by Seraph on 2020/3/15.
//  Copyright © 2020 Paradise. All rights reserved.
//

import XCTest

class DMUserListPageItem: DMBasePage {

    let cellElement: XCUIElement
    
    lazy var avatarView = cellElement.images["avatarView"]
    lazy var userNameLabel = cellElement.staticTexts["userNameLabel"]
    
    init(testCase: XCTestCase, element: XCUIElement) {
        self.cellElement = element
        super.init(testCase: testCase)
    }
    
    required init(testCase: XCTestCase) {
        fatalError("init(testCase:) has not been implemented")
    }
    
    @discardableResult
    func checkItemExistence() -> Self {
        expect(elements: [avatarView, userNameLabel], status: .exists, timeout: .normal, message: "DMUserListPageItem elements not found")
        return self
    }
    
}
