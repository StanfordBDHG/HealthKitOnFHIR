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

    func testAbdominalCramps() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.abdominalCramps),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.abdominalCramps).description,
                    display: "Abdominal Cramps"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testAcne() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.acne),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.acne).description,
                    display: "Acne"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testBladderIncontinence() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.bladderIncontinence),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.bladderIncontinence).description,
                    display: "Bladder Incontinence"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testBloating() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.bloating),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.bloating).description,
                    display: "Bloating"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testBreastPain() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.breastPain),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.breastPain).description,
                    display: "Breast Pain"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testChestTightnessOrPain() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.chestTightnessOrPain),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.chestTightnessOrPain).description,
                    display: "Chest Tightness Or Pain"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testChills() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.chills),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.chills).description,
                    display: "Chills"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testConstipation() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.constipation),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.constipation).description,
                    display: "Constipation"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testCoughing() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.coughing),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.coughing).description,
                    display: "Coughing"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testDizziness() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.dizziness),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.dizziness).description,
                    display: "Dizziness"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testDrySkin() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.drySkin),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.drySkin).description,
                    display: "Dry Skin"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testFainting() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.fainting),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.fainting).description,
                    display: "Fainting"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testFever() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.fever),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.fever).description,
                    display: "Fever"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testGeneralizedBodyAche() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.generalizedBodyAche),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.generalizedBodyAche).description,
                    display: "Generalized Body Ache"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testHairLoss() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.hairLoss),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.hairLoss).description,
                    display: "Hair Loss"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testHeadache() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.headache),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.headache).description,
                    display: "Headache"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testHeartburn() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.heartburn),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.heartburn).description,
                    display: "Heartburn"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testHotFlashes() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.hotFlashes),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.hotFlashes).description,
                    display: "Hot Flashes"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testLossOfSmell() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.lossOfSmell),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.lossOfSmell).description,
                    display: "Loss Of Smell"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testLossOfTaste() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.lossOfTaste),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.lossOfTaste).description,
                    display: "Loss Of Taste"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testLowerBackPain() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.lowerBackPain),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.lowerBackPain).description,
                    display: "Lower Back Pain"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testMemoryLapse() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.memoryLapse),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.memoryLapse).description,
                    display: "Memory Lapse"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testMoodChanges() throws {
        let values: [HKCategoryValuePresence] = [.notPresent, .present]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.moodChanges),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.moodChanges).description,
                    display: "Mood Changes"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testSleepChanges() throws {
        let values: [HKCategoryValuePresence] = [.notPresent, .present]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.sleepChanges),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.sleepChanges).description,
                    display: "Sleep Changes"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testNausea() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.nausea),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.nausea).description,
                    display: "Nausea"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testNightSweats() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.nightSweats),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.nightSweats).description,
                    display: "Night Sweats"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testPelvicPain() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.pelvicPain),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.pelvicPain).description,
                    display: "Pelvic Pain"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testRapidPoundingOrFlutteringHeartbeat() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.rapidPoundingOrFlutteringHeartbeat),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.rapidPoundingOrFlutteringHeartbeat).description,
                    display: "Rapid Pounding Or Fluttering Heartbeat"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testRunnyNose() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.runnyNose),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.runnyNose).description,
                    display: "Runny Nose"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testShortnessOfBreath() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.shortnessOfBreath),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.shortnessOfBreath).description,
                    display: "Shortness Of Breath"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testSinusCongestion() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.sinusCongestion),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.sinusCongestion).description,
                    display: "Sinus Congestion"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testSkippedHeartbeat() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.skippedHeartbeat),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.skippedHeartbeat).description,
                    display: "Skipped Heartbeat"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testSoreThroat() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.soreThroat),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.soreThroat).description,
                    display: "Sore Throat"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testVaginalDryness() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.vaginalDryness),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.vaginalDryness).description,
                    display: "Vaginal Dryness"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testVomiting() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.vomiting),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.vomiting).description,
                    display: "Vomiting"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

    func testWheezing() throws {
        let values: [HKCategoryValueSeverity] = [.moderate, .unspecified, .notPresent, .severe, .mild]

        for value in values {
            let observation = try createObservationFrom(
                type: HKCategoryType(.wheezing),
                value: value.rawValue
            )

            XCTAssertEqual(
                observation.code.coding?.first,
                createCategoryCoding(
                    categoryType: HKCategoryType(.wheezing).description,
                    display: "Wheezing"
                )
            )

            XCTAssertEqual(
                observation.value,
                .string(value.description.asFHIRStringPrimitive())
            )
        }
    }

}
