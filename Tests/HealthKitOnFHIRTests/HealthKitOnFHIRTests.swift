//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import HealthKitOnFHIR
import XCTest

// swiftlint:disable file_length
// We disable the file length rule as this is a test class
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

    enum codeSystem: String {
        case loinc = "http://loinc.org"
        case apple = "https://developer.apple.com/documentation/healthkit"
        case snomedCT = "http://snomed.info/sct"
    }

    func createCoding(code: String, display: String, system: codeSystem) -> Coding {
        Coding(
            code: FHIRPrimitive(stringLiteral: code),
            display: FHIRPrimitive(stringLiteral: display),
            system: FHIRPrimitive(FHIRURI(stringLiteral: system.rawValue))
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
                createCoding(
                    code: "41653-7",
                    display: "Glucose Glucometer (BldC) [Mass/Vol]",
                    system: .loinc
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "mg/dL",
                    system: "http://unitsofmeasure.org",
                    unit: "mg/dL",
                    value: 99.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryBiotin() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryBiotin),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 100)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "700183008",
                    display: "Biotin intake (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "ug",
                    system: "http://unitsofmeasure.org",
                    unit: "ug",
                    value: 100.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryCaffeine() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryCaffeine),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 100)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "1208604004",
                    display: "Caffeine intake (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "mg",
                    system: "http://unitsofmeasure.org",
                    unit: "mg",
                    value: 100.asFHIRDecimalPrimitive()
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
                createCoding(
                    code: "55423-8",
                    display: "Number of steps in unspecified time Pedometer",
                    system: .loinc
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
                createCoding(
                    code: "8867-4",
                    display: "Heart rate",
                    system: .loinc
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "/min",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "beats/minute",
                    value: 84.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testRestingHeartRateSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.restingHeartRate),
            quantity: HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 84)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "40443-4",
                    display: "Heart rate --resting",
                    system: .loinc
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "/min",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "beats/minute",
                    value: 84.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testWalkingHeartRateAverage() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.walkingHeartRateAverage),
            quantity: HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 84)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "HKQuantityTypeIdentifierWalkingHeartRateAverage",
                    display: "Walking Heart Rate Average",
                    system: .apple
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "/min",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "beats/minute",
                    value: 84.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testHeartRateVariabilitySDNNSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.heartRateVariabilitySDNN),
            quantity: HKQuantity(unit: .secondUnit(with: .milli), doubleValue: 100)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "80404-7",
                    display: "R-R interval.standard deviation (Heart rate variability)",
                    system: .loinc
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "ms",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "ms",
                    value: 100.asFHIRDecimalPrimitive()
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
                createCoding(
                    code: "59408-5",
                    display: "Oxygen saturation in Arterial blood by Pulse oximetry",
                    system: .loinc
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "%",
                    system: "http://unitsofmeasure.org",
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
                createCoding(
                    code: "8310-5",
                    display: "Body temperature",
                    system: .loinc
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "Cel",
                    system: "http://unitsofmeasure.org",
                    unit: "C",
                    value: 37.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testBasalBodyTemperatureSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.basalBodyTemperature),
            quantity: HKQuantity(unit: .degreeCelsius(), doubleValue: 37)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "300076005",
                    display: "Basal body temperature (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "Cel",
                    system: "http://unitsofmeasure.org",
                    unit: "C",
                    value: 37.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testBasalEnergyBurnedSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.basalEnergyBurned),
            quantity: HKQuantity(unit: HKUnit(from: "kcal"), doubleValue: 1200)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "HKQuantityTypeIdentifierBasalEnergyBurned",
                    display: "Basal energy burned",
                    system: .apple
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "kcal",
                    system: "http://unitsofmeasure.org",
                    unit: "kcal",
                    value: 1200.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testBloodAlcoholContentSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bloodAlcoholContent),
            quantity: HKQuantity(unit: .percent(), doubleValue: 0.0)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "74859-0",
                    display: "Ethanol [Mass/volume] in Blood Estimated from serum or plasma level",
                    system: .loinc
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "%",
                    system: "http://unitsofmeasure.org",
                    unit: "%",
                    value: 0.0.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testBodyFatPercentageSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bodyFatPercentage),
            quantity: HKQuantity(unit: .percent(), doubleValue: 21)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "41982-0",
                    display: "Percentage of body fat Measured",
                    system: .loinc
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "%",
                    system: "http://unitsofmeasure.org",
                    unit: "%",
                    value: 21.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testBodyMassIndexSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bodyMassIndex),
            quantity: HKQuantity(unit: .count(), doubleValue: 20)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "39156-5",
                    display: "Body mass index (BMI) [Ratio]",
                    system: .loinc
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "kg/m2",
                    system: "http://unitsofmeasure.org",
                    unit: "kg/m^2",
                    value: 20.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testHeightSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.height),
            quantity: HKQuantity(unit: .inch(), doubleValue: 64)
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "8302-2",
                    display: "Body height",
                    system: .loinc
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "[in_i]",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "in",
                    value: 64.asFHIRDecimalPrimitive()
                )
            )
        )
    }
    
    func testBodyMassSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bodyMass),
            quantity: HKQuantity(unit: .pound(), doubleValue: 60)
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "29463-7",
                    display: "Body weight",
                    system: .loinc
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "[lb_av]",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "lbs",
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
                createCoding(
                    code: "9279-1",
                    display: "Respiratory rate",
                    system: .loinc
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "/min",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "breaths/minute",
                    value: 18.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testActiveEnergyBurnedSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.activeEnergyBurned),
            quantity: HKQuantity(unit: .largeCalorie(), doubleValue: 100)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "41981-2",
                    display: "Calories burned",
                    system: .loinc
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "kcal",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "kcal",
                    value: 100.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testAppleExerciseTimeSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.appleExerciseTime),
            quantity: HKQuantity(unit: .minute(), doubleValue: 100)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "HKQuantityTypeIdentifierAppleExerciseTime",
                    display: "Apple Exercise Time",
                    system: .apple
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "min",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "min",
                    value: 100.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testAppleMoveTimeSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.appleMoveTime),
            quantity: HKQuantity(unit: .minute(), doubleValue: 100)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "HKQuantityTypeIdentifierAppleMoveTime",
                    display: "Apple Move Time",
                    system: .apple
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "min",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "min",
                    value: 100.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testAppleStandTimeSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.appleStandTime),
            quantity: HKQuantity(unit: .minute(), doubleValue: 100)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "HKQuantityTypeIdentifierAppleStandTime",
                    display: "Apple Stand Time",
                    system: .apple
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "min",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "min",
                    value: 100.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testEnvironmentalAudioExposureSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.environmentalAudioExposure),
            quantity: HKQuantity(unit: .decibelAWeightedSoundPressureLevel(), doubleValue: 100)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "HKQuantityTypeIdentifierEnvironmentalAudioExposure",
                    display: "Environmental Audio Exposure",
                    system: .apple
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "dB(SPL)",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "dB(SPL)",
                    value: 100.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testHeadphoneAudioExposureSample() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.headphoneAudioExposure),
            quantity: HKQuantity(unit: .decibelAWeightedSoundPressureLevel(), doubleValue: 100)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "HKQuantityTypeIdentifierHeadphoneAudioExposure",
                    display: "Headphone Audio Exposure",
                    system: .apple
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "dB(SPL)",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "dB(SPL)",
                    value: 100.asFHIRDecimalPrimitive()
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
                    code: "mm[Hg]",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                    unit: "mmHg",
                    value: 120.asFHIRDecimalPrimitive()
                )
            )
        }.count)

        XCTAssertEqual(1, observation.component?.filter {
            $0.value == .quantity(
                Quantity(
                    code: "mm[Hg]",
                    system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
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

    func testInvalidComponent() throws {
        let vitaminC = HKQuantitySample(
            type: HKQuantityType(.dietaryVitaminC),
            quantity: HKQuantity(unit: .gram(), doubleValue: 1),
            start: try startDate,
            end: try endDate
        )

        let correlation = HKCorrelation(
            type: HKCorrelationType(.bloodPressure),
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
