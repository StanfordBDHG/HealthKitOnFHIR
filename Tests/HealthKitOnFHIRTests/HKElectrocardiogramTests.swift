//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import HealthKitOnFHIR
import XCTest


class HKElectrocardiogramTests: XCTestCase {
    func testElectrocardiogramCategoryTests() throws {
        try XCTAssertEqual(HKElectrocardiogram.SymptomsStatus.notSet.categoryValueDescription, "notSet")
        try XCTAssertEqual(HKElectrocardiogram.SymptomsStatus.none.categoryValueDescription, "none")
        try XCTAssertEqual(HKElectrocardiogram.SymptomsStatus.present.categoryValueDescription, "present")
        
        try XCTAssertEqual(HKElectrocardiogram.Classification.notSet.categoryValueDescription, "notSet")
        try XCTAssertEqual(HKElectrocardiogram.Classification.sinusRhythm.categoryValueDescription, "sinusRhythm")
        try XCTAssertEqual(HKElectrocardiogram.Classification.atrialFibrillation.categoryValueDescription, "atrialFibrillation")
        try XCTAssertEqual(HKElectrocardiogram.Classification.inconclusiveLowHeartRate.categoryValueDescription, "inconclusiveLowHeartRate")
        try XCTAssertEqual(HKElectrocardiogram.Classification.inconclusiveHighHeartRate.categoryValueDescription, "inconclusiveHighHeartRate")
        try XCTAssertEqual(HKElectrocardiogram.Classification.inconclusivePoorReading.categoryValueDescription, "inconclusivePoorReading")
        try XCTAssertEqual(HKElectrocardiogram.Classification.inconclusiveOther.categoryValueDescription, "inconclusiveOther")
        try XCTAssertEqual(HKElectrocardiogram.Classification.unrecognized.categoryValueDescription, "unrecognized")
    }
}
