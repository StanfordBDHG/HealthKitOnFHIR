//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import HealthKitOnFHIR
import XCTest


final class HealthKitOnFHIRTests: XCTestCase {
    private var startDate: Date {
        get throws {
            let dateComponents = DateComponents(year: 1891, month: 10, day: 1, hour: 12, minute: 0, second: 0) // Date Stanford University opened (https://www.stanford.edu/about/history/)
            return try XCTUnwrap(Calendar.current.date(from: dateComponents))
        }
    }
    
    private var endDate: Date {
        get throws {
            let dateComponents = DateComponents(year: 1891, month: 10, day: 1, hour: 12, minute: 0, second: 42)
            return try XCTUnwrap(Calendar.current.date(from: dateComponents))
        }
    }

    func testBloodGlucose() throws {
        let sampleType = HKQuantityType(.bloodGlucose)
        let bloodGlucoseSample = HKDiscreteQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: HKUnit(from: "mg/dL"), doubleValue: 99),
            start: try startDate,
            end: try endDate
        )

        let observation = try bloodGlucoseSample.observation

        XCTAssertEqual(observation.code.coding, sampleType.convertToCodes())

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "mg/dL".asFHIRStringPrimitive(),
                    value: 99.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testStepCount() throws {
        let sampleType = HKQuantityType(.stepCount)
        let stepCountSample = HKCumulativeQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: try startDate,
            end: try endDate
        )

        let observation = try stepCountSample.observation

        XCTAssertEqual(observation.code.coding, sampleType.convertToCodes())

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "steps".asFHIRStringPrimitive(),
                    value: 42.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testHeartRateSample() throws {
        let unit = HKUnit.count().unitDivided(by: .minute())
        let sampleType = HKQuantityType(.heartRate)
        let heartRateSample = HKDiscreteQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: unit, doubleValue: 84),
            start: try startDate,
            end: try endDate
        )

        let observation = try heartRateSample.observation

        XCTAssertEqual(observation.code.coding, sampleType.convertToCodes())

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "count/min".asFHIRStringPrimitive(),
                    value: 84.asFHIRDecimalPrimitive()
                )
            )
        )
    }
}
