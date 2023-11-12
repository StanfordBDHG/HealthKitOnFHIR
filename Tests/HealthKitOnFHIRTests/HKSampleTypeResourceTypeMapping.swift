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
        try XCTAssertEqual(HKQuantityType(.activeEnergyBurned).resourceType, .observation)
        try XCTAssertEqual(HKCorrelationType(.bloodPressure).resourceType, .observation)
        try XCTAssertEqual(HKCategoryType(.abdominalCramps).resourceType, .observation)

        XCTAssertThrowsError(try HKSampleType.workoutType().resourceType)
    }
    
    func testHKClinicalTypeMappingToResourceType() throws {
        try XCTAssertEqual(HKClinicalType(.allergyRecord).resourceType, .allergyIntolerance)
        try XCTAssertEqual(HKClinicalType(.conditionRecord).resourceType, .condition)
        try XCTAssertEqual(HKClinicalType(.coverageRecord).resourceType, .coverage)
        try XCTAssertEqual(HKClinicalType(.immunizationRecord).resourceType, .immunization)
        try XCTAssertEqual(HKClinicalType(.labResultRecord).resourceType, .observation)
        try XCTAssertEqual(HKClinicalType(.medicationRecord).resourceType, .medication)
        try XCTAssertEqual(HKClinicalType(.procedureRecord).resourceType, .procedure)
        try XCTAssertEqual(HKClinicalType(.vitalSignRecord).resourceType, .observation)
    }
}
