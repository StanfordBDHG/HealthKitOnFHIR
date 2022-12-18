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
        categoryType: String
    ) -> Coding {
        Coding(
            code: FHIRPrimitive(stringLiteral: categoryType),
            display: FHIRPrimitive(stringLiteral: categoryType),
            system: FHIRPrimitive(FHIRURI(stringLiteral: SupportedCodeSystem.apple.rawValue))
        )
    }

    func testCervicalMucusQuality() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.cervicalMucusQuality),
            value: HKCategoryValueCervicalMucusQuality.dry.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.cervicalMucusQuality).description))
        XCTAssertEqual(observation.value, .string("dry".asFHIRStringPrimitive()))
    }

    func testMenstrualFlow() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.menstrualFlow),
            value: HKCategoryValueMenstrualFlow.light.rawValue,
            metadata: [HKMetadataKeyMenstrualCycleStart: true]
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.menstrualFlow).description))
        XCTAssertEqual(observation.value, .string("light".asFHIRStringPrimitive()))
    }

    func testOvulationTestResult() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.ovulationTestResult),
            value: HKCategoryValueOvulationTestResult.luteinizingHormoneSurge.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.ovulationTestResult).description))
        XCTAssertEqual(
            observation.value, .string("luteinizing hormone surge".asFHIRStringPrimitive())
        )
    }

    func testContraceptive() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.contraceptive),
            value: HKCategoryValueContraceptive.implant.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.contraceptive).description))
        XCTAssertEqual(observation.value, .string("implant".asFHIRStringPrimitive()))
    }

    func testSleepAnalysis() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.sleepAnalysis),
            value: HKCategoryValueSleepAnalysis.inBed.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.sleepAnalysis).description))
        XCTAssertEqual(observation.value, .string("in bed".asFHIRStringPrimitive()))
    }

    func testAppetiteChanges() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.appetiteChanges),
            value: HKCategoryValueAppetiteChanges.increased.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.appetiteChanges).description))
        XCTAssertEqual(observation.value, .string("increased".asFHIRStringPrimitive()))
    }

    func testEnvironmentAudioExposureEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.environmentalAudioExposureEvent),
            value: HKCategoryValueEnvironmentalAudioExposureEvent.momentaryLimit.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.environmentalAudioExposureEvent).description)
        )
        XCTAssertEqual(observation.value, .string("momentary limit".asFHIRStringPrimitive()))
    }

    func testHeadphoneAudioExposureEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.headphoneAudioExposureEvent),
            value: HKCategoryValueHeadphoneAudioExposureEvent.sevenDayLimit.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.headphoneAudioExposureEvent).description))
        XCTAssertEqual(observation.value, .string("seven day limit".asFHIRStringPrimitive()))
    }

    func testLowCardioFitnessEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.lowCardioFitnessEvent),
            value: HKCategoryValueLowCardioFitnessEvent.lowFitness.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.lowCardioFitnessEvent).description))
        XCTAssertEqual(observation.value, .string("low fitness".asFHIRStringPrimitive()))
    }

    func testAppleWalkingSteadinessEvent() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.appleWalkingSteadinessEvent),
            value: HKCategoryValueAppleWalkingSteadinessEvent.initialLow.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.appleWalkingSteadinessEvent).description))
        XCTAssertEqual(observation.value, .string("initial low".asFHIRStringPrimitive()))
    }

    func testPregnancyTestResult() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.pregnancyTestResult),
            value: HKCategoryValuePregnancyTestResult.positive.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.pregnancyTestResult).description))
        XCTAssertEqual(observation.value, .string("positive".asFHIRStringPrimitive()))
    }

    func testProgesteroneTestResult() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.progesteroneTestResult),
            value: HKCategoryValueProgesteroneTestResult.positive.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.progesteroneTestResult).description))
        XCTAssertEqual(observation.value, .string("positive".asFHIRStringPrimitive()))
    }

    func testAppleStandHour() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.appleStandHour),
            value: HKCategoryValueAppleStandHour.stood.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.appleStandHour).description))
        XCTAssertEqual(observation.value, .string("stood".asFHIRStringPrimitive()))
    }

    func testIntermenstrualBleeding() throws {
        let observation = try createObservationFrom(
            type: HKCategoryType(.intermenstrualBleeding),
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.intermenstrualBleeding).description))
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

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.infrequentMenstrualCycles).description))
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

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.irregularMenstrualCycles).description))
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
            observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.persistentIntermenstrualBleeding).description)
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

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.prolongedMenstrualPeriods).description))
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

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.lactation).description))
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

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.handwashingEvent).description))
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

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.toothbrushingEvent).description))
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

        XCTAssertEqual(observation.code.coding?.first, createCategoryCoding(categoryType: HKCategoryType(.mindfulSession).description))
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierMindfulSession".asFHIRStringPrimitive())
        )
    }
}
