//
//  DMUserListPage.swift
//  DirectMessageUITests
//
//  Created by Seraph on 2020/3/15.
//  Copyright © 2020 Paradise. All rights reserved.
//

import XCTest

class DMUserListPage: DMBasePage {

    lazy var title = self.app.navigationBars.staticTexts["Github DM"]
    lazy var tableView = self.app.tables.firstMatch
    
    required init(testCase: XCTestCase) {
        super.init(testCase: testCase)
        expect(elements: [title, tableView], status: .exists, timeout: .normal, message: "DMUserListPage elements not found")
    }
    
    func visibleItems() -> [DMUserListPageItem]? {
        let cells = self.tableView.cells
        guard cells.count > 0 else { return nil }
        var messageViews: [DMUserListPageItem] = []
        for cellElement in cells.allElementsBoundByIndex {
            messageViews.append(DMUserListPageItem(testCase: self.testCase, element: cellElement))
        }
        return messageViews
    }
    
    func enterChatroom(contains name: String) -> Self {
        expect(element: tableView, status: .exists, timeout: .normal, message: "tableView not found")
        let element = self.app.tables.cells.containing(NSPredicate(format: "label CONTAINS '\(name)'")).firstMatch
        scrollTo(element: element, in: tableView, direction: .downward)
        tap(element: element, errorMessage: "cell not hittable nor not found")
        return self
    }

}
