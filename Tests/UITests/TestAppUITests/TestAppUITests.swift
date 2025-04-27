//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest
import XCTestExtensions
import XCTHealthKit


class TestAppUITests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
    }
    
    
    @MainActor
    func testHealthKitOnFHIR() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Write Data
        XCTAssert(app.collectionViews.buttons["Write Data"].waitForExistence(timeout: 5))
        app.collectionViews.buttons["Write Data"].tap()
        
        XCTAssert(app.collectionViews.textFields["Number of steps..."].waitForExistence(timeout: 5))
        try app.collectionViews.textFields["Number of steps..."].enter(value: "2")
        
        app.collectionViews.buttons["Write Step Count"].tap()
        
        // Enable Apple Health Access if needed
        try app.handleHealthKitAuthorization()
        
        // Check that the data is written
        XCTAssert(app.collectionViews.staticTexts["Data successfully written!"].waitForExistence(timeout: 5))
        
        // Return back to the main view
        app.navigationBars["Write Data"].buttons["HealthKitOnFHIR Tests"].tap()
        
        // Check that the data can be read
        app.collectionViews.buttons["Read Data"].tap()
        app.collectionViews.buttons["Read Step Count"].tap()
        
        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }
    
    @MainActor
    func testECGHealthKitMapping() throws {
        let app = XCUIApplication()
        app.launch()
        
        try launchAndAddSample(healthApp: .healthApp, .electrocardiogram())

        app.launch()
        XCTAssert(app.wait(for: .runningForeground, timeout: 6.0))

        XCTAssert(app.staticTexts["Electrocardiogram"].waitForExistence(timeout: 5))
        app.staticTexts["Electrocardiogram"].tap()
        XCTAssert(app.buttons["Read Electrocardiogram"].waitForExistence(timeout: 5))
        app.buttons["Read Electrocardiogram"].tap()
        
        // Enable Apple Health Access if needed
        try app.handleHealthKitAuthorization()
        
        XCTAssert(app.staticTexts["Passed"].waitForExistence(timeout: 10))
        
        app.collectionViews.buttons["See JSON"].tap()
        
        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }

    @MainActor
    func testWorkoutMapping() throws {
        let app = XCUIApplication()
        app.launch()

        // Create Workout
        XCTAssert(app.collectionViews.buttons["Create Workout"].waitForExistence(timeout: 5))
        app.collectionViews.buttons["Create Workout"].tap()
        XCTAssert(app.collectionViews.buttons["Create Sample Workout"].waitForExistence(timeout: 5))
        app.collectionViews.buttons["Create Sample Workout"].tap()

        // Enable Apple Health Access if needed
        try app.handleHealthKitAuthorization()

        // Dismiss results view
        app.swipeDown(velocity: XCUIGestureVelocity.fast)
    }
    
    @MainActor
    func testMappingCompleteness() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Mapping Completeness"].tap()
        XCTAssertTrue(app.staticTexts["All Fine!"].waitForExistence(timeout: 2))
    }
}
