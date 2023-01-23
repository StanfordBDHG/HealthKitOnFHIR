//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import HealthKitOnFHIR
import ModelsR4
import XCTest


class HKSampleTypeResourceTypeMapping: XCTestCase {
    func testHKSampleTypeMappingToObservation() {
        try XCTAssertEqual(HKQuantityType(.activeEnergyBurned).resourceTyoe, .observation)
        try XCTAssertEqual(HKCorrelationType(.bloodPressure).resourceTyoe, .observation)
        try XCTAssertEqual(HKCategoryType(.abdominalCramps).resourceTyoe, .observation)
        
        XCTAssertThrowsError(try HKSampleType.workoutType().resourceTyoe)
    }
    
    func testHKClinicalTypeMappingToResourceType() throws {
        try XCTAssertEqual(HKClinicalType(.allergyRecord).resourceTyoe, .allergyIntolerance)
        try XCTAssertEqual(HKClinicalType(.conditionRecord).resourceTyoe, .condition)
        try XCTAssertEqual(HKClinicalType(.coverageRecord).resourceTyoe, .coverage)
        try XCTAssertEqual(HKClinicalType(.immunizationRecord).resourceTyoe, .immunization)
        try XCTAssertEqual(HKClinicalType(.labResultRecord).resourceTyoe, .observation)
        try XCTAssertEqual(HKClinicalType(.medicationRecord).resourceTyoe, .medication)
        try XCTAssertEqual(HKClinicalType(.procedureRecord).resourceTyoe, .procedure)
        try XCTAssertEqual(HKClinicalType(.vitalSignRecord).resourceTyoe, .observation)
    }
}
