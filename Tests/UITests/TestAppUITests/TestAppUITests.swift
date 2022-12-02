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
        
        continueAfterFailure = false
    }
    
    
    func testHealthKitOnFHIR() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Write Data
        app.collectionViews.buttons["Write Data"].tap()
        
        let numberOfStepsTextField = app.collectionViews.textFields["Number of steps..."]
        numberOfStepsTextField.tap()
        numberOfStepsTextField.typeText("2")
        
        app.collectionViews.buttons["Write Step Count"].tap()
        
        // Enable Apple Health Access if needed
        _ = app.navigationBars["Health Access"].waitForExistence(timeout: 10)
        if app.navigationBars["Health Access"].waitForExistence(timeout: 10) {
            app.tables.staticTexts["Turn On All"].tap()
            app.navigationBars["Health Access"].buttons["Allow"].tap()
        }
        
        // Check that the data is written
        sleep(2)
        XCTAssert(app.collectionViews.staticTexts["Data successfully written!"].waitForExistence(timeout: 5))
        
        // Return back to the main view
        app.navigationBars["Write Data"].buttons["HealthKitOnFHIR Tests"].tap()
        
        // Check that the data can be read
        app.collectionViews.buttons["Read Data"].tap()
        app.collectionViews.buttons["Read Step Count"].tap()
        
        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }
}
