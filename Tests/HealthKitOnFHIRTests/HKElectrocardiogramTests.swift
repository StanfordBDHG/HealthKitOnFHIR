//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
@testable import HealthKitOnFHIR
import XCTest


class HKElectrocardiogramTests: XCTestCase {
    func testElectrocardiogramCategoryTests() throws {
        try XCTAssertEqual(HKElectrocardiogram.SymptomsStatus.notSet.fhirCategoryValue, "notSet")
        try XCTAssertEqual(HKElectrocardiogram.SymptomsStatus.none.fhirCategoryValue, "none")
        try XCTAssertEqual(HKElectrocardiogram.SymptomsStatus.present.fhirCategoryValue, "present")
        
        try XCTAssertEqual(HKElectrocardiogram.Classification.notSet.fhirCategoryValue, "notSet")
        try XCTAssertEqual(HKElectrocardiogram.Classification.sinusRhythm.fhirCategoryValue, "sinusRhythm")
        try XCTAssertEqual(HKElectrocardiogram.Classification.atrialFibrillation.fhirCategoryValue, "atrialFibrillation")
        try XCTAssertEqual(HKElectrocardiogram.Classification.inconclusiveLowHeartRate.fhirCategoryValue, "inconclusiveLowHeartRate")
        try XCTAssertEqual(HKElectrocardiogram.Classification.inconclusiveHighHeartRate.fhirCategoryValue, "inconclusiveHighHeartRate")
        try XCTAssertEqual(HKElectrocardiogram.Classification.inconclusivePoorReading.fhirCategoryValue, "inconclusivePoorReading")
        try XCTAssertEqual(HKElectrocardiogram.Classification.inconclusiveOther.fhirCategoryValue, "inconclusiveOther")
        try XCTAssertEqual(HKElectrocardiogram.Classification.unrecognized.fhirCategoryValue, "unrecognized")
    }
}
