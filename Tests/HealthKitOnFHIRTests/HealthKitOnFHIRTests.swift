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
        let bloodGlucoseSample = HKQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: HKUnit(from: "mg/dL"), doubleValue: 99),
            start: try startDate,
            end: try endDate
        )
        
        let observation = try bloodGlucoseSample.observation
        
        XCTAssertEqual(observation.code.coding, sampleType.codes)
        
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
        let stepCountSample = HKQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: .count(), doubleValue: 42),
            start: try startDate,
            end: try endDate
        )
        
        let observation = try stepCountSample.observation
        
        XCTAssertEqual(observation.code.coding, sampleType.codes)
        
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
        let heartRateSample = HKQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: unit, doubleValue: 84),
            start: try startDate,
            end: try endDate
        )
        
        let observation = try heartRateSample.observation
        
        XCTAssertEqual(observation.code.coding, sampleType.codes)
        
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
    
    func testOxygenSaturationSample() throws {
        let unit = HKUnit.percent()
        let sampleType = HKQuantityType(.oxygenSaturation)
        let oxygenSaturationSample = HKQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: unit, doubleValue: 99),
            start: try startDate,
            end: try endDate
        )
        
        let observation = try oxygenSaturationSample.observation
        
        XCTAssertEqual(observation.code.coding, sampleType.codes)
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "%".asFHIRStringPrimitive(),
                    value: 99.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testBodyTemperatureSample() throws {
        let unit = HKUnit.degreeCelsius()
        let sampleType = HKQuantityType(.bodyTemperature)
        let bodyTemperatureSample = HKQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: unit, doubleValue: 37),
            start: try startDate,
            end: try startDate
        )
        
        let observation = try bodyTemperatureSample.observation
        
        XCTAssertEqual(observation.code.coding, sampleType.codes)
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "degC".asFHIRStringPrimitive(),
                    value: 37.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testHeightSample() throws {
        let unit = HKUnit.meter()
        let sampleType = HKQuantityType(.height)
        let heightSample = HKQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: unit, doubleValue: 1.77),
            start: try startDate,
            end: try startDate
        )
        
        let observation = try heightSample.observation
        
        XCTAssertEqual(observation.code.coding, sampleType.codes)
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "m".asFHIRStringPrimitive(),
                    value: 1.77.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testBodyMassSample() throws {
        let unit = HKUnit.gramUnit(with: .kilo)
        let sampleType = HKQuantityType(.bodyMass)
        let bodyMassSample = HKQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: unit, doubleValue: 60),
            start: try startDate,
            end: try startDate
        )
        
        let observation = try bodyMassSample.observation
        
        XCTAssertEqual(observation.code.coding, sampleType.codes)
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "kg".asFHIRStringPrimitive(),
                    value: 60.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testRespiratoryRateSample() throws {
        let unit = HKUnit(from: "count/min")
        let sampleType = HKQuantityType(.respiratoryRate)
        let respiratoryRateSample = HKQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: unit, doubleValue: 18),
            start: try startDate,
            end: try endDate
        )
        
        let observation = try respiratoryRateSample.observation
        
        XCTAssertEqual(observation.code.coding, sampleType.codes)
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "count/min".asFHIRStringPrimitive(),
                    value: 18.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testUnsupportedTypeSample() throws {
        let unit = HKUnit.gram()
        let sampleType = HKQuantityType(.dietaryVitaminC)
        let vitaminCSample = HKQuantitySample(
            type: sampleType,
            quantity: HKQuantity(unit: unit, doubleValue: 1),
            start: try startDate,
            end: try endDate
        )
        XCTAssertThrowsError(try vitaminCSample.observation)
    }
}
