//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest


class TestAppUITests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = true
    }
    
    func testHealthKitOnFHIR() throws {

        if ProcessInfo.processInfo.environment["SIMULATOR_HOST_HOME"] == "/Users/runner" {
                    throw XCTSkip("The GitHub Action environment does not support interactions with the HealthApp, therefore we don't run the tests for now.")
                }

        let app = XCUIApplication()
        app.launch()

        // Write step count sample
        let valueField = app.textFields.element(boundBy: 0)
        app.collectionViews.buttons["Write Data"].tap()
        valueField.tap()
        valueField.typeText("2")
        app.collectionViews.buttons["Write Step Count"].tap()

        // Authorize HealthKit read/write access
        lazy var turnOnAllCategories = app.tables.cells.firstMatch
        lazy var allowCategories = app.navigationBars.buttons.element(boundBy: 1)

        if turnOnAllCategories.waitForExistence(timeout: 10.0) {
            turnOnAllCategories.tap()
            allowCategories.tap()
        }

        // Check if data write was successful
        let expectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.staticTexts["Data successfully written!"],
            handler: .none
        )
        let result = XCTWaiter.wait(for: [expectation], timeout: 10.0)
        XCTAssertEqual(result, .completed)

        // Navigate back to home screen
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // Read all step count samples
        app.collectionViews.buttons["Read Data"].tap()
        app.collectionViews.buttons["Read Step Count"].tap()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }
}
