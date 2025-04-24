//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
@testable import HealthKitOnFHIR
import ModelsR4
import XCTest

// swiftlint:disable file_length type_body_length
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
        type categoryType: HKCategoryTypeIdentifier,
        value: Int,
        metadata: [String: Any] = [:]
    ) throws -> Observation {
        let categorySample = HKCategorySample(
            type: HKCategoryType(categoryType),
            value: value,
            start: try startDate,
            end: try endDate,
            metadata: metadata
        )
        return try XCTUnwrap(categorySample.resource().get(if: Observation.self))
    }

    func createCategoryCoding(
        categoryType: HKCategoryTypeIdentifier,
        display: String
    ) -> Coding {
        Coding(
            code: FHIRPrimitive(stringLiteral: categoryType.rawValue),
            display: FHIRPrimitive(stringLiteral: display),
            system: FHIRPrimitive(FHIRURI(stringLiteral: SupportedCodeSystem.apple.rawValue))
        )
    }

    func testCervicalMucusQuality() throws {
        let values: [HKCategoryValueCervicalMucusQuality] = [.dry, .sticky, .creamy, .watery, .eggWhite]

        for value in values {
            let observation = try createObservationFrom(
                type: .cervicalMucusQuality,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .cervicalMucusQuality,
                    display: "Cervical Mucus Quality"
                )
            )
            XCTAssertEqual(observation.value, .string(try value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    func testMenstrualFlow() throws {
        let values: [HKCategoryValueMenstrualFlow] = [.unspecified, .light, .medium, .heavy, .none]

        for value in values {
            let observation = try createObservationFrom(
                type: .menstrualFlow,
                value: value.rawValue,
                metadata: [HKMetadataKeyMenstrualCycleStart: true]
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .menstrualFlow,
                    display: "Menstrual Flow"
                )
            )
            XCTAssertEqual(observation.value, .string(try value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    func testOvulationTestResult() throws {
        let values: [HKCategoryValueOvulationTestResult] = [.negative, .indeterminate, .luteinizingHormoneSurge, .estrogenSurge]

        for value in values {
            let observation = try createObservationFrom(
                type: .ovulationTestResult,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .ovulationTestResult,
                    display: "Ovulation Test Result"
                )
            )
            XCTAssertEqual(
                observation.value, .string(try value.fhirCategoryValue.asFHIRStringPrimitive())
            )
        }
    }

    func testContraceptive() throws {
        let values: [HKCategoryValueContraceptive] = [.unspecified, .implant, .injection, .intrauterineDevice, .intravaginalRing, .oral, .patch]

        for value in values {
            let observation = try createObservationFrom(
                type: .contraceptive,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .contraceptive,
                    display: "Contraceptive"
                )
            )
            XCTAssertEqual(observation.value, .string(try value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    func testSleepAnalysis() throws {
        let values: [HKCategoryValueSleepAnalysis] = [.inBed, .asleepUnspecified, .awake, .asleepCore, .asleepDeep, .asleepREM]

        for value in values {
            let observation = try createObservationFrom(
                type: .sleepAnalysis,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .sleepAnalysis,
                    display: "Sleep Analysis"
                )
            )
            XCTAssertEqual(observation.value, .string(try value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    func testAppetiteChanges() throws {
        let values: [HKCategoryValueAppetiteChanges] = [.unspecified, .noChange, .decreased, .increased]

        for value in values {
            let observation = try createObservationFrom(
                type: .appetiteChanges,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .appetiteChanges,
                    display: "Appetite Changes"
                )
            )
            XCTAssertEqual(observation.value, .string(try value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    func testEnvironmentalAudioExposureEvent() throws {
        let observation = try createObservationFrom(
            type: .environmentalAudioExposureEvent,
            value: HKCategoryValueEnvironmentalAudioExposureEvent.momentaryLimit.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .environmentalAudioExposureEvent,
                display: "Environmental Audio Exposure Event"
            )
        )
        XCTAssertEqual(observation.value, .string("momentary limit".asFHIRStringPrimitive()))
    }

    func testHeadphoneAudioExposureEvent() throws {
        let observation = try createObservationFrom(
            type: .headphoneAudioExposureEvent,
            value: HKCategoryValueHeadphoneAudioExposureEvent.sevenDayLimit.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .headphoneAudioExposureEvent,
                display: "Headphone Audio Exposure Event"
            )
        )
        XCTAssertEqual(observation.value, .string("seven day limit".asFHIRStringPrimitive()))
    }

    func testLowCardioFitnessEvent() throws {
        let observation = try createObservationFrom(
            type: .lowCardioFitnessEvent,
            value: HKCategoryValueLowCardioFitnessEvent.lowFitness.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .lowCardioFitnessEvent,
                display: "Low Cardio Fitness Event"
            )
        )
        XCTAssertEqual(observation.value, .string("low fitness".asFHIRStringPrimitive()))
    }

    func testAppleWalkingSteadinessEvent() throws {
        let values: [HKCategoryValueAppleWalkingSteadinessEvent] = [.initialLow, .initialVeryLow, .repeatLow, .repeatVeryLow]

        for value in values {
            let observation = try createObservationFrom(
                type: .appleWalkingSteadinessEvent,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .appleWalkingSteadinessEvent,
                    display: "Apple Walking Steadiness Event"
                )
            )
            XCTAssertEqual(observation.value, .string(try value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    func testAppleWalkingSteadinessClassification() throws {
        let okClassification = try HKAppleWalkingSteadinessClassification(
            rawValue: HKAppleWalkingSteadinessClassification.ok.rawValue
        )?.fhirCategoryValue
        XCTAssertEqual(okClassification, "ok")

        let lowClassification = try HKAppleWalkingSteadinessClassification(
            rawValue: HKAppleWalkingSteadinessClassification.low.rawValue
        )?.fhirCategoryValue
        XCTAssertEqual(lowClassification, "low")

        let veryLowClassification = try HKAppleWalkingSteadinessClassification(
            rawValue: HKAppleWalkingSteadinessClassification.veryLow.rawValue
        )?.fhirCategoryValue
        XCTAssertEqual(veryLowClassification, "very low")
    }

    func testPregnancyTestResult() throws {
        let values: [HKCategoryValuePregnancyTestResult] = [.negative, .positive, .indeterminate]

        for value in values {
            let observation = try createObservationFrom(
                type: .pregnancyTestResult,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .pregnancyTestResult,
                    display: "Pregnancy Test Result"
                )
            )
            XCTAssertEqual(observation.value, .string(try value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    func testProgesteroneTestResult() throws {
        let values: [HKCategoryValueProgesteroneTestResult] = [.indeterminate, .positive, .negative]

        for value in values {
            let observation = try createObservationFrom(
                type: .progesteroneTestResult,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .progesteroneTestResult,
                    display: "Progesterone Test Result"
                )
            )
            XCTAssertEqual(observation.value, .string(try value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    func testAppleStandHour() throws {
        let values: [HKCategoryValueAppleStandHour] = [.stood, .idle]

        for value in values {
            let observation = try createObservationFrom(
                type: .appleStandHour,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .appleStandHour,
                    display: "Apple Stand Hour"
                )
            )
            XCTAssertEqual(observation.value, .string(try value.fhirCategoryValue.asFHIRStringPrimitive()))
        }
    }

    func testIntermenstrualBleeding() throws {
        let observation = try createObservationFrom(
            type: .intermenstrualBleeding,
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .intermenstrualBleeding,
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
            type: .infrequentMenstrualCycles,
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .infrequentMenstrualCycles,
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
            type: .irregularMenstrualCycles,
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .irregularMenstrualCycles,
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
            type: .persistentIntermenstrualBleeding,
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .persistentIntermenstrualBleeding,
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
            type: .prolongedMenstrualPeriods,
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .prolongedMenstrualPeriods,
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
            type: .lactation,
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .lactation,
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
            type: .handwashingEvent,
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .handwashingEvent,
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
            type: .toothbrushingEvent,
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .toothbrushingEvent,
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
            type: .mindfulSession,
            value: HKCategoryValue.notApplicable.rawValue
        )

        XCTAssertEqual(
            observation.code.coding?.first,
            createCategoryCoding(
                categoryType: .mindfulSession,
                display: "Mindful Session"
            )
        )
        XCTAssertEqual(
            observation.value,
            .string("HKCategoryTypeIdentifierMindfulSession".asFHIRStringPrimitive())
        )
    }

    // SYMPTOM TESTS

    func testSymptoms(type: HKCategoryTypeIdentifier, display: String) throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: type,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: type,
                    display: display
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(try value.fhirCategoryValue.asFHIRStringPrimitive())
            )
        }
    }

    func testAbdominalCramps() throws {
        try testSymptoms(type: .abdominalCramps, display: "Abdominal Cramps")
    }

    func testAcne() throws {
        try testSymptoms(type: .acne, display: "Acne")
    }

    func testBladderIncontinence() throws {
        try testSymptoms(type: .bladderIncontinence, display: "Bladder Incontinence")
    }

    func testBloating() throws {
        try testSymptoms(type: .bloating, display: "Bloating")
    }

    func testBreastPain() throws {
        try testSymptoms(type: .breastPain, display: "Breast Pain")
    }

    func testChestTightnessOrPain() throws {
        try testSymptoms(type: .chestTightnessOrPain, display: "Chest Tightness Or Pain")
    }

    func testChills() throws {
        try testSymptoms(type: .chills, display: "Chills")
    }

    func testConstipation() throws {
        try testSymptoms(type: .constipation, display: "Constipation")
    }

    func testCoughing() throws {
        try testSymptoms(type: .coughing, display: "Coughing")
    }

    func testDizziness() throws {
        try testSymptoms(type: .dizziness, display: "Dizziness")
    }

    func testDrySkin() throws {
        try testSymptoms(type: .drySkin, display: "Dry Skin")
    }

    func testFainting() throws {
        try testSymptoms(type: .fainting, display: "Fainting")
    }

    func testFever() throws {
        try testSymptoms(type: .fever, display: "Fever")
    }

    func testGeneralizedBodyAche() throws {
        try testSymptoms(type: .generalizedBodyAche, display: "Generalized Body Ache")
    }

    func testHairLoss() throws {
        try testSymptoms(type: .hairLoss, display: "Hair Loss")
    }

    func testHeadache() throws {
        try testSymptoms(type: .headache, display: "Headache")
    }

    func testHeartburn() throws {
        try testSymptoms(type: .heartburn, display: "Heartburn")
    }

    func testHotFlashes() throws {
        try testSymptoms(type: .hotFlashes, display: "Hot Flashes")
    }

    func testLossOfSmell() throws {
        try testSymptoms(type: .lossOfSmell, display: "Loss Of Smell")
    }

    func testLossOfTaste() throws {
        try testSymptoms(type: .lossOfTaste, display: "Loss Of Taste")
    }

    func testLowerBackPain() throws {
        try testSymptoms(type: .lowerBackPain, display: "Lower Back Pain")
    }

    func testMemoryLapse() throws {
        try testSymptoms(type: .memoryLapse, display: "Memory Lapse")
    }

    func testMoodChanges() throws {
        let values: [HKCategoryValuePresence] = [.notPresent, .present]

        for value in values {
            let observation = try createObservationFrom(
                type: .moodChanges,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .moodChanges,
                    display: "Mood Changes"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(try value.fhirCategoryValue.asFHIRStringPrimitive())
            )
        }
    }

    func testSleepChanges() throws {
        let values: [HKCategoryValuePresence] = [.notPresent, .present]

        for value in values {
            let observation = try createObservationFrom(
                type: .sleepChanges,
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: .sleepChanges,
                    display: "Sleep Changes"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(try value.fhirCategoryValue.asFHIRStringPrimitive())
            )
        }
    }

    func testNausea() throws {
        try testSymptoms(type: .nausea, display: "Nausea")
    }

    func testNightSweats() throws {
        try testSymptoms(type: .nightSweats, display: "Night Sweats")
    }

    func testPelvicPain() throws {
        try testSymptoms(type: .pelvicPain, display: "Pelvic Pain")
    }

    func testRapidPoundingOrFlutteringHeartbeat() throws {
        try testSymptoms(type: .rapidPoundingOrFlutteringHeartbeat, display: "Rapid Pounding Or Fluttering Heartbeat")
    }

    func testRunnyNose() throws {
        try testSymptoms(type: .runnyNose, display: "Runny Nose")
    }

    func testShortnessOfBreath() throws {
        try testSymptoms(type: .shortnessOfBreath, display: "Shortness Of Breath")
    }

    func testSinusCongestion() throws {
        try testSymptoms(type: .sinusCongestion, display: "Sinus Congestion")
    }

    func testSkippedHeartbeat() throws {
        try testSymptoms(type: .skippedHeartbeat, display: "Skipped Heartbeat")
    }

    func testSoreThroat() throws {
        try testSymptoms(type: .soreThroat, display: "Sore Throat")
    }

    func testVaginalDryness() throws {
        try testSymptoms(type: .vaginalDryness, display: "Vaginal Dryness")
    }

    func testVomiting() throws {
        try testSymptoms(type: .vomiting, display: "Vomiting")
    }

    func testWheezing() throws {
        try testSymptoms(type: .wheezing, display: "Wheezing")
    }
}
