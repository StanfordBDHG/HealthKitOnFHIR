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
        try healthKitAccess()
        
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
    
    func testECGHealthKitMapping() throws {
        let app = XCUIApplication()
        app.launch()
        
        try exitAppAndOpenHealth(.electrocardiograms)
        
        XCTAssert(app.buttons["Electrocardiogram"].waitForExistence(timeout: 2))
        app.buttons["Electrocardiogram"].tap()
        XCTAssert(app.buttons["Read Electrocardiogram"].waitForExistence(timeout: 0.5))
        app.buttons["Read Electrocardiogram"].tap()
        
        // Enable Apple Health Access if needed
        try healthKitAccess()
        
        XCTAssert(app.staticTexts["Passed"].waitForExistence(timeout: 10))
        
        app.collectionViews.buttons["See JSON"].tap()
        
        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }
    
    
    private func healthKitAccess() throws {
        let app = XCUIApplication()
        
        if app.navigationBars["Health Access"].waitForExistence(timeout: 10) {
            app.tables.staticTexts["Turn On All"].tap()
            app.navigationBars["Health Access"].buttons["Allow"].tap()
            return
        }
        print("The HealthKit View did not load after 10 seconds ... give it a second try with a timeout of 20 seconds.")
        if app.navigationBars["Health Access"].waitForExistence(timeout: 20) {
            app.tables.staticTexts["Turn On All"].tap()
            app.navigationBars["Health Access"].buttons["Allow"].tap()
        }
    }
}
