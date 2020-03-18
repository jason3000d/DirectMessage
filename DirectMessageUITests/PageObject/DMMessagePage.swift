//
//  DMMessagePage.swift
//  DirectMessageUITests
//
//  Created by Seraph on 2020/3/15.
//  Copyright © 2020 Paradise. All rights reserved.
//

import XCTest

class DMMessagePage: DMBasePage {
    
    lazy var tableView = self.app.tables.firstMatch

    required init(testCase: XCTestCase) {
        super.init(testCase: testCase)
        expect(elements: [tableView], status: .exists, timeout: .normal, message: "DMMessagePage elements not found")
    }
        
    func validateTextMessage(with text: String) -> Self {
        expect(elementQuary: self.tableView.cells, contains: text, timeout: .normal, message: "text message not found")
        return self
    }

}
