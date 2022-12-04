//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import HealthKitOnFHIR
import XCTest


class HealthKitOnFHIRTests: XCTestCase {
    // swiftlint:disable:previous type_body_length
    // We disable the type body length as this is a test class

    var startDate: Date {
        get throws {
            let dateComponents = DateComponents(year: 1891, month: 10, day: 1, hour: 12, minute: 0, second: 0) // Date Stanford University opened (https://www.stanford.edu/about/history/)
            return try XCTUnwrap(Calendar.current.date(from: dateComponents))
        }
    }
    
    var endDate: Date {
        get throws {
            let dateComponents = DateComponents(year: 1891, month: 10, day: 1, hour: 12, minute: 0, second: 42)
            return try XCTUnwrap(Calendar.current.date(from: dateComponents))
        }
    }
    
    
    func createObservationFrom(
        type quantityType: HKQuantityType,
        quantity: HKQuantity
    ) throws -> Observation {
        let quantitySample = HKQuantitySample(
            type: quantityType,
            quantity: quantity,
            start: try startDate,
            end: try endDate
        )
        return try quantitySample.observation
    }
    
    func loincCode(code: String, display: String) -> Coding {
        Coding(
            code: FHIRPrimitive(stringLiteral: code),
            display: FHIRPrimitive(stringLiteral: display),
            system: FHIRPrimitive(FHIRURI(stringLiteral: "http://loinc.org"))
        )
    }
    
    func testBloodGlucose() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bloodGlucose),
            quantity: HKQuantity(unit: HKUnit(from: "mg/dL"), doubleValue: 99)
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                loincCode(
                    code: "41653-7",
                    display: "Glucose Glucometer (BldC) [Mass/Vol]"
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "mg/dL",
                    value: 99.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testStepCount() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42)
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                loincCode(
                    code: "55423-8",
                    display: "Number of steps in unspecified time Pedometer"
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "steps",
                    value: 42.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testHeartRateSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.heartRate),
            quantity: HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 84)
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                loincCode(
                    code: "8867-4",
                    display: "Heart rate"
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "beats/min",
                    value: 84.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testOxygenSaturationSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.oxygenSaturation),
            quantity: HKQuantity(unit: .percent(), doubleValue: 99)
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                loincCode(
                    code: "59408-5",
                    display: "Oxygen saturation in Arterial blood by Pulse oximetry"
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "%",
                    value: 99.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testBodyTemperatureSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bodyTemperature),
            quantity: HKQuantity(unit: .degreeCelsius(), doubleValue: 37)
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                loincCode(
                    code: "8310-5",
                    display: "Body temperature"
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "degC",
                    value: 37.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testHeightSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.height),
            quantity: HKQuantity(unit: .meter(), doubleValue: 1.77)
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                loincCode(
                    code: "8302-2",
                    display: "Body height"
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "m",
                    value: 1.77.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testBodyMassSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bodyMass),
            quantity: HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 60)
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                loincCode(
                    code: "29463-7",
                    display: "Body weight"
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "kg",
                    value: 60.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testRespiratoryRateSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.respiratoryRate),
            quantity: HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 18)
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                loincCode(
                    code: "9279-1",
                    display: "Respiratory rate"
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "count/min",
                    value: 18.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testBloodPressureCorrelation() throws {
        let systolicBloodPressure = HKQuantitySample(
            type: HKQuantityType(.bloodPressureSystolic),
            quantity: HKQuantity(unit: .millimeterOfMercury(), doubleValue: 120),
            start: try startDate,
            end: try endDate
        )

        let diastolicBloodPressure = HKQuantitySample(
            type: HKQuantityType(.bloodPressureDiastolic),
            quantity: HKQuantity(unit: .millimeterOfMercury(), doubleValue: 80),
            start: try startDate,
            end: try endDate
        )

        let correlation = HKCorrelation(
            type: HKCorrelationType(.bloodPressure),
            start: try startDate,
            end: try endDate,
            objects: [systolicBloodPressure, diastolicBloodPressure]
        )

        let observation = try correlation.observation

        XCTAssertEqual(1, observation.component?.filter {
            $0.value == .quantity(
                Quantity(
                    unit: "mmHg",
                    value: 120.asFHIRDecimalPrimitive()
                )
            )
        }.count)

        XCTAssertEqual(1, observation.component?.filter {
            $0.value == .quantity(
                Quantity(
                    unit: "mmHg",
                    value: 80.asFHIRDecimalPrimitive()
                )
            )
        }.count)
    }
    
    func testUnsupportedTypeSample() throws {
        XCTAssertThrowsError(
            try createObservationFrom(
                type: HKQuantityType(.dietaryVitaminC),
                quantity: HKQuantity(unit: .gram(), doubleValue: 1)
            )
        )
    }

    func testUnsupportedCorrelation() throws {
        // Food correlations are not currently supported
        let vitaminC = HKQuantitySample(
            type: HKQuantityType(.dietaryVitaminC),
            quantity: HKQuantity(unit: .gram(), doubleValue: 1),
            start: try startDate,
            end: try endDate
        )

        let correlation = HKCorrelation(
            type: HKCorrelationType(.food),
            start: try startDate,
            end: try endDate,
            objects: [vitaminC]
        )
        XCTAssertThrowsError(try correlation.observation)
    }
    
    func testUnsupportedType() throws {
        XCTAssertThrowsError(
            try HKWorkout(activityType: .running, start: Date(), end: Date()).observation
        )
    }

    func testUnsupportedMapping() throws {
        let sample = HKQuantitySample(
            type: HKQuantityType(.dietaryVitaminC),
            quantity: HKQuantity(unit: .gram(), doubleValue: 1),
            start: try startDate,
            end: try endDate
        )

        XCTAssertEqual(sample.quantityType.codes, [])
    }
}
