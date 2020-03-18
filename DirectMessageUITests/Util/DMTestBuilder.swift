//
//  DMTestBuilder.swift
//  DirectMessageUITests
//
//  Created by Seraph on 2020/3/15.
//  Copyright © 2020 Paradise. All rights reserved.
//

import XCTest

class DMTestBuilder {
    let app = XCUIApplication()
    let testCase: XCTestCase

    required init(testCase: XCTestCase) {
        self.testCase = testCase
        self.app.launchArguments += ["isUITests"]
    }

    @discardableResult
    func launch() -> Self {
        app.launch()
        return self
    }

    @discardableResult
    func terminate() -> Self {
        app.terminate()
        return self
    }

}
