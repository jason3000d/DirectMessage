//
//  DMInputBoxViewPage.swift
//  DirectMessageUITests
//
//  Created by Seraph on 2020/3/15.
//  Copyright © 2020 Paradise. All rights reserved.
//

import XCTest

class DMInputBoxViewPage: DMBasePage {

    lazy var inputBoxView = self.app.textFields["inputBoxView"]
    lazy var sendButton = self.app.buttons["sendButton"]
    
    required init(testCase: XCTestCase) {
        super.init(testCase: testCase)
        expect(elements: [inputBoxView, sendButton], status: .exists, timeout: .normal, message: "DMInputBoxViewPage elements not found")
    }
    
    func sendText(_ content: String) -> Self {
        tap(element: self.inputBoxView, errorMessage: "Failed, inputBoxView is not hittable or not found")
        typeText(element: self.inputBoxView, text: content, errorMessage: "Failed, error when inputting content")
        tap(element: self.sendButton, errorMessage: "Failed, send button is not hittable or not found")
        return self
    }

}
