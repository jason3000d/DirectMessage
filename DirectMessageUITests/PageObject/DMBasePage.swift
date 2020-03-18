//
//  DMBasePage.swift
//  DirectMessageUITests
//
//  Created by Seraph on 2020/3/15.
//  Copyright © 2020 Paradise. All rights reserved.
//

import XCTest

enum DMTimeout: TimeInterval {
    case short = 5.0
    case normal = 15.0
    case long = 30.0
}

enum UIStatus: String {
    case exists = "exists == true"
    case notExists = "exists == false"
    case selected = "selected == true"
    case notSelected = "selected == false"
    case hittable = "hittable == true"
    case unHittable = "hittable == false"

    case countEqualToZero = "count = 0"
    case countGreaterThanZero = "count > 0"
}

enum UIDirection {
    case downward
    case upward
}

class DMBasePage {

    let testCase: XCTestCase
    let app = XCUIApplication()

    required init(testCase: XCTestCase) {
        self.testCase = testCase
    }

    func on<T: DMBasePage>(page: T.Type) -> T {
        return page.init(testCase: self.testCase)
    }

    func back() -> Self {
        let backButton = self.app.navigationBars.buttons["Back"]
        tap(element: backButton, errorMessage: "Back button not exists")
        return self
    }

    func checkExistence<T: DMBasePage>(page: T.Type) -> Self {
        XCTAssertNotNil(self, "\(page) not exists")
        return self
    }

    // MARK: expectations
    func expect(element: XCUIElement, status: UIStatus, timeout: DMTimeout, function: String = #function, message: String) {
        expect(elements: element, predicate: NSPredicate(format: status.rawValue), timeout: timeout, function: function, message: message)
    }

    func expect(elements: [XCUIElement], status: UIStatus, timeout: DMTimeout, function: String = #function, message: String) {
        expect(elements: elements, predicate: NSPredicate(format: status.rawValue), timeout: timeout, function: function, message: message)
    }

    func expect(elementQuery: XCUIElementQuery, status: UIStatus, timeout: DMTimeout, function: String = #function, message: String) {
        expect(elements: elementQuery, predicate: NSPredicate(format: status.rawValue), timeout: timeout, function: function, message: message)
    }

    func expect(elementQueries: [XCUIElementQuery], status: UIStatus, timeout: DMTimeout, function: String = #function, message: String) {
        expect(elements: elementQueries, predicate: NSPredicate(format: status.rawValue), timeout: timeout, function: function, message: message)
    }

    func expect(elementQuary: XCUIElementQuery, contains phrase: String, existense: Bool = true, timeout: DMTimeout, function: String = #function, message: String) {
        let predicate = NSPredicate(format: "label CONTAINS '\(phrase)'")
        let query = elementQuary.containing(predicate)
        expect(elementQuery: query, status: (existense ? .countGreaterThanZero : .countEqualToZero), timeout: timeout, function: function, message: message)
    }

    func expect(text: String, equalTo phrase: String, existense: Bool = true, timeout: DMTimeout, function: String = #function, message: String) {
        let predicate = NSPredicate(format: "'\(text)' == '\(phrase)'")
        expect(elements: text, predicate: predicate, timeout: timeout, function: function, message: message)
    }

    func expect(text: String, contains phrase: String, existense: Bool = true, timeout: DMTimeout, function: String = #function, message: String) {
        let predicate = NSPredicate(format: "'\(text)' CONTAINS '\(phrase)'")
        expect(elements: text, predicate: predicate, timeout: timeout, function: function, message: message)
    }

    func expect(elements: Any, predicate: NSPredicate, timeout: DMTimeout, function: String = #function, message: String) {
        let result = expectWithResult(elements: elements, predicate: predicate, timeout: timeout, message: message)
        let msg = "Failed to find \(elements) after \(timeout.rawValue) seconds. function: \(function), \(message)"
        if result != .completed {
            self.testCase.recordFailure(withDescription: msg, inFile: #file, atLine: #line, expected: true)
        }
    }

    func expectWithResult(elements: Any, predicate: NSPredicate, timeout: DMTimeout, function: String = #function, message: String) -> XCTWaiter.Result {
        var expectations = [XCTestExpectation]()
        if let array = elements as? [Any] {
            for element in array {
                let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
                expectations.append(expectation)
            }
        } else {
            let expectation = XCTNSPredicateExpectation(predicate: predicate, object: elements)
            expectations.append(expectation)
        }

        return XCTWaiter.wait(for: expectations, timeout: timeout.rawValue)
    }

    // MARK: actions
    func tap(element: XCUIElement, function: String = #function, errorMessage: String) {
        expect(element: element, status: .hittable, timeout: .normal, message: errorMessage)
        element.tap()
    }

    func press(element: XCUIElement, duration: TimeInterval = 1, function: String = #function, errorMessage: String) {
        expect(element: element, status: .hittable, timeout: .short, message: errorMessage)
        element.press(forDuration: duration)
    }

    func swipeUp(element: XCUIElement, function: String = #function, errorMessage: String) {
        expect(element: element, status: .hittable, timeout: .normal, message: errorMessage)
        let start = element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0.5))
        let end = element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0.0))
        start.press(forDuration: 0.0, thenDragTo: end)
    }

    func swipeDown(element: XCUIElement, function: String = #function, errorMessage: String) {
        expect(element: element, status: .hittable, timeout: .normal, message: errorMessage)
        let start = element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0.5))
        let end = element.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 1.0))
        start.press(forDuration: 0.0, thenDragTo: end)
    }

    func typeText(element: XCUIElement, text: String, validate: Bool = true, function: String = #function, errorMessage: String) {
        tap(element: element, errorMessage: errorMessage)
        element.typeText(text)
        guard validate == true else {
            return
        }
        guard let value = element.value as? String,
            value == text
        else {
            XCTFail("Failed, text view content should be inserted")
            return
        }
    }

    func scrollTo(element: XCUIElement, in scrollView: XCUIElement, direction: UIDirection, function: String = #function) {
        let maxScrollTry = 10
        var currentTry = 0
        let errorMessage = "element not found"

        while (currentTry < maxScrollTry) {
            if element.exists && element.isHittable {
                return
            }
            if direction == .downward {
                swipeUp(element: scrollView, function: function, errorMessage: errorMessage)
            } else {
                swipeDown(element: scrollView, function: function, errorMessage: errorMessage)
            }
            currentTry += 1
        }
        XCTFail("element not exists")
    }

    func validate(element: XCUIElement, existence: Bool, function: String = #function) -> Self {
        if existence == false {
            XCTAssertFalse(element.exists, "Failed: \(element) shouldn't have exist")
        } else {
            expect(element: element, status: .exists, timeout: .normal, function: function, message: "Failed: \(element) should have exist")
        }
        return self
    }

    // MARK: helpers
    func errorMessage(with functionName: String = #function, description: String) -> String {
        return "\(functionName): \(description)"
    }

}
