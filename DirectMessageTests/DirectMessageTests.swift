//
//  DirectMessageTests.swift
//  DirectMessageTests
//
//  Created by Seraph on 2020/3/8.
//  Copyright © 2020 Paradise. All rights reserved.
//

import XCTest
@testable import DirectMessage

class DirectMessageTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetUserList() {
        
        let exp = expectation(description: "exp")
        DMBaseService.shared.getUserList { (users, error) in
            guard error == nil,
                let firstUser = users?.first else {
                XCTFail("error occur")
                 return
            }
            XCTAssertNotNil(firstUser.username)
            XCTAssertNotNil(firstUser.id)
            XCTAssertNotNil(firstUser.nodeId)
            XCTAssertNotNil(firstUser.avatarUrl)
            XCTAssertNotNil(firstUser.gravatarId)
            XCTAssertNotNil(firstUser.url)
            XCTAssertNotNil(firstUser.htmlUrl)
            XCTAssertNotNil(firstUser.type)
            XCTAssertNotNil(firstUser.siteAdmin)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 60)
    }

}
