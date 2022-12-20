//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import HealthKitOnFHIR
import XCTest


class HKCategorySampleTests: XCTestCase {
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
        type categoryType: HKCategoryType,
        value: Int,
        metadata: [String: Any] = [:]
    ) throws -> Observation {
        let categorySample = HKCategorySample(
            type: categoryType,
            value: value,
            start: try startDate,
            end: try endDate,
            metadata: metadata
        )
        return try categorySample.observation
    }

    func createCategoryCoding(
        categoryType: String,
        display: String
    ) -> Coding {
        Coding(
            code: FHIRPrimitive(stringLiteral: categoryType),
            display: FHIRPrimitive(stringLiteral: display),
            system: FHIRPrimitive(FHIRURI(stringLiteral: SupportedCodeSystem.apple.rawValue))
        )
    }

    func testCervicalMucusQuality() throws {
        let values: [HKCategoryValueCervicalMucusQuality] = [.dry, .sticky, .creamy, .watery, .eggWhite]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.cervicalMucusQuality),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.cervicalMucusQuality).description,
                    display: "Cervical Mucus Quality"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testMenstrualFlow() throws {
        let values: [HKCategoryValueMenstrualFlow] = [.unspecified, .light, .medium, .heavy, .none]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.menstrualFlow),
                value: value.rawValue,
                metadata: [HKMetadataKeyMenstrualCycleStart: true]
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.menstrualFlow).description, display: "Menstrual Flow"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testOvulationTestResult() throws {
        let values: [HKCategoryValueOvulationTestResult] = [.negative, .indeterminate, .luteinizingHormoneSurge, .estrogenSurge]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.ovulationTestResult),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.ovulationTestResult).description,
                    display: "Ovulation Test Result"
                )
            )
            XCTAssertEqual(
                observation.value, .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testContraceptive() throws {
        let values: [HKCategoryValueContraceptive] = [.unspecified, .implant, .injection, .intrauterineDevice, .intravaginalRing, .oral, .patch]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.contraceptive),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.contraceptive).description,
                    display: "Contraceptive"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testSleepAnalysis() throws {
        let values: [HKCategoryValueSleepAnalysis] = [.inBed, .asleepUnspecified, .awake, .asleepCore, .asleepDeep, .asleepREM]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.sleepAnalysis),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.sleepAnalysis).description,
                    display: "Sleep Analysis"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testAppetiteChanges() throws {
        let values: [HKCategoryValueAppetiteChanges] = [.unspecified, .noChange, .decreased, .increased]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.appetiteChanges),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.appetiteChanges).description,
                    display: "Appetite Changes"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testEnvironmentalAudioExposureEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.environmentalAudioExposureEvent),
            value: HKCategoryValueEnvironmentalAudioExposureEvent.momentaryLimit.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.environmentalAudioExposureEvent).description,
                display: "Environmental Audio Exposure Event"
            )
        )
        XCTAssertEqual(observation.value, .string("momentary limit".asFHIRStringPrimitive()))
    }

    func testHeadphoneAudioExposureEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.headphoneAudioExposureEvent),
            value: HKCategoryValueHeadphoneAudioExposureEvent.sevenDayLimit.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.headphoneAudioExposureEvent).description,
                display: "Headphone Audio Exposure Event"
            )
        )
        XCTAssertEqual(observation.value, .string("seven day limit".asFHIRStringPrimitive()))
    }

    func testLowCardioFitnessEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.lowCardioFitnessEvent),
            value: HKCategoryValueLowCardioFitnessEvent.lowFitness.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.lowCardioFitnessEvent).description,
                display: "Low Cardio Fitness Event"
            )
        )
        XCTAssertEqual(observation.value, .string("low fitness".asFHIRStringPrimitive()))
    }

    func testAppleWalkingSteadinessEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.appleWalkingSteadinessEvent),
            value: HKCategoryValueAppleWalkingSteadinessEvent.initialLow.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.appleWalkingSteadinessEvent).description,
                display: "Apple Walking Steadiness Event"
            )
        )
        XCTAssertEqual(observation.value, .string("initial low".asFHIRStringPrimitive()))
    }

    func testPregnancyTestResult() throws {
        let values: [HKCategoryValuePregnancyTestResult] = [.negative, .positive, .indeterminate]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.pregnancyTestResult),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.pregnancyTestResult).description,
                    display: "Pregnancy Test Result"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testProgesteroneTestResult() throws {
        let values: [HKCategoryValueProgesteroneTestResult] = [.indeterminate, .positive, .negative]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.progesteroneTestResult),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.progesteroneTestResult).description,
                    display: "Progesterone Test Result"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testAppleStandHour() throws {
        let values: [HKCategoryValueAppleStandHour] = [.stood, .idle]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.appleStandHour),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.appleStandHour).description,
                    display: "Apple Stand Hour"
                )
            )
            XCTAssertEqual(observation.value, .string(value.description.asFHIRStringPrimitive()))
        }
    }

    func testIntermenstrualBleeding() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.intermenstrualBleeding),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.intermenstrualBleeding).description,
                display: "Intermenstrual Bleeding"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierIntermenstrualBleeding".asFHIRStringPrimitive())
        )
    }

    func testInfrequentMenstrualCycles() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.infrequentMenstrualCycles),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.infrequentMenstrualCycles).description,
                display: "Infrequent Menstrual Cycles"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierInfrequentMenstrualCycles".asFHIRStringPrimitive())
        )
    }

    func testIrregularMenstrualCycles() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.irregularMenstrualCycles),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.irregularMenstrualCycles).description,
                display: "Irregular Menstrual Cycles"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierIrregularMenstrualCycles".asFHIRStringPrimitive())
        )
    }

    func testPersistentIntermenstrualBleeding() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.persistentIntermenstrualBleeding),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.persistentIntermenstrualBleeding).description,
                display: "Persistent Intermenstrual Bleeding"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierPersistentIntermenstrualBleeding".asFHIRStringPrimitive())
        )
    }

    func testProlongedMenstrualPeriods() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.prolongedMenstrualPeriods),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.prolongedMenstrualPeriods).description,
                display: "Prolonged Menstrual Periods"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierProlongedMenstrualPeriods".asFHIRStringPrimitive())
        )
    }

    func testLactation() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.lactation),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.lactation).description,
                display: "Lactation"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierLactation".asFHIRStringPrimitive())
        )
    }

    func testHandwashingEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.handwashingEvent),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.handwashingEvent).description,
                display: "Handwashing Event"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierHandwashingEvent".asFHIRStringPrimitive())
        )
    }

    func testToothbrushingEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.toothbrushingEvent),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.toothbrushingEvent).description,
                display: "Toothbrushing Event"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierToothbrushingEvent".asFHIRStringPrimitive())
        )
    }

    func testMindfulSession() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.mindfulSession),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: HKCategoryType(.mindfulSession).description,
                display: "Mindful Session"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierMindfulSession".asFHIRStringPrimitive())
        )
    }
}