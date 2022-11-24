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
    
    func testCumulativeQuantitySample() throws {
        let cumulativeQuantitySample = HKCumulativeQuantitySample(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: try startDate,
            end: try endDate
        )

        let observation = try cumulativeQuantitySample.observation

        // Print out the FHIR Observation JSON
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(observation)
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
        }

        guard let loincSystem = URL(string: "http://loinc.org") else {
            return
        }
        let loincCoding = Coding(
            code: "55423-8".asFHIRStringPrimitive(),
            display: "Number of steps in unspecified time Pedometer".asFHIRStringPrimitive(),
            system: loincSystem.asFHIRURIPrimitive()
        )
        XCTAssertEqual(observation.code.coding, [loincCoding])

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
    
    
    func testdiscreteQuantitySample() throws {
        let unit = HKUnit.count().unitDivided(by: .minute())
        let discreteQuantitySample = HKDiscreteQuantitySample(
            type: HKQuantityType(.heartRate),
            quantity: HKQuantity(unit: unit, doubleValue: 84),
            start: try startDate,
            end: try endDate
        )
        XCTAssertThrowsError(try discreteQuantitySample.observation)
    }
}
