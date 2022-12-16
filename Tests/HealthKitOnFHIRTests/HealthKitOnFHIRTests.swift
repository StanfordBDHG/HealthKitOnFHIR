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
    enum CodeSystem: String {
        case loinc = "http://loinc.org"
        case apple = "https://developer.apple.com/documentation/healthkit"
        case snomedCT = "http://snomed.info/sct"
    }

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

    func createCoding(code: String, display: String, system: CodeSystem) -> Coding {
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

    func testDietaryCalcium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryCalcium),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1000)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "230122008",
                    display: "Calcium intake (observable entity)",
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
                    value: 1000.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryCarbohydrates() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryCarbohydrates),
            quantity: HKQuantity(unit: .gram(), doubleValue: 1000)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "788472008",
                    display: "Carbohydrate intake (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "g",
                    system: "http://unitsofmeasure.org",
                    unit: "g",
                    value: 1000.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryChloride() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryChloride),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 2300)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "1148944005",
                    display: "Chloride salt intake (observable entity)",
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
                    value: 2300.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryCholesterol() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryCholesterol),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 100)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "HKQuantityTypeIdentifierDietaryCholesterol",
                    display: "Dietary Cholesterol",
                    system: .apple
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

    func testDietaryChromium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryChromium),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 25)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "890196009",
                    display: "Chromium intake (observable entity)",
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
                    value: 25.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryCopper() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryCopper),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 900)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286615007",
                    display: "Copper intake (observable entity)",
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
                    value: 900.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryFatMonounsaturated() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFatMonounsaturated),
            quantity: HKQuantity(unit: .gram(), doubleValue: 22)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "226329008",
                    display: "Monounsaturated fat intake (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "g",
                    system: "http://unitsofmeasure.org",
                    unit: "g",
                    value: 22.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryFatPolyunsaturated() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFatPolyunsaturated),
            quantity: HKQuantity(unit: .gram(), doubleValue: 30)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "226330003",
                    display: "Polyunsaturated fat intake (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "g",
                    system: "http://unitsofmeasure.org",
                    unit: "g",
                    value: 30.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryFatSaturated() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFatSaturated),
            quantity: HKQuantity(unit: .gram(), doubleValue: 30)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "226328000",
                    display: "Saturated fat intake (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "g",
                    system: "http://unitsofmeasure.org",
                    unit: "g",
                    value: 30.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryFatTotal() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFatTotal),
            quantity: HKQuantity(unit: .gram(), doubleValue: 66)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "897147002",
                    display: "Measured quantity of fat and oil intake (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "g",
                    system: "http://unitsofmeasure.org",
                    unit: "g",
                    value: 66.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryFiber() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFiber),
            quantity: HKQuantity(unit: .gram(), doubleValue: 30)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "LP203183-1",
                    display: "Fiber intake",
                    system: .loinc
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "g",
                    system: "http://unitsofmeasure.org",
                    unit: "g",
                    value: 30.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryFolate() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFolate),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 400)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "792806007",
                    display: "Folate and/or folate derivative intake (observable entity)",
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
                    value: 400.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryIodine() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryIodine),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 140)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "890199002",
                    display: "Iodine intake (observable entity)",
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
                    value: 140.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryMagnesium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryMagnesium),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 400)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "230124009",
                    display: "Magnesium intake (observable entity)",
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
                    value: 400.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryManganese() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryManganese),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 2.3)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "890198005",
                    display: "Manganese intake (observable entity)",
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
                    value: 2.3.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryMolybdenum() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryMolybdenum),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 45)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "890200004",
                    display: "Molybdenum intake (observable entity)",
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
                    value: 45.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryPhosphorus() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryPhosphorus),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1000)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "230123003",
                    display: "Phosphorus intake (observable entity)",
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
                    value: 1000.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryPotassium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryPotassium),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1000)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "788479004",
                    display: "Potassium intake (observable entity)",
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
                    value: 1000.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietarySodium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietarySodium),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1000)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "1148504005",
                    display: "Sodium intake (observable entity)",
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
                    value: 1000.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryNiacin() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryNiacin),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 16)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286583002",
                    display: "Niacin intake (observable entity)",
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
                    value: 16.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryPantothenicAcid() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryPantothenicAcid),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 5)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286600006",
                    display: "Pantothenic acid intake (observable entity)",
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
                    value: 5.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryProtein() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryProtein),
            quantity: HKQuantity(unit: .gram(), doubleValue: 40)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "1179049004",
                    display: "Measured quantity of intake of protein and/or protein derivative (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "g",
                    system: "http://unitsofmeasure.org",
                    unit: "g",
                    value: 40.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryRiboflavin() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryRiboflavin),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1.3)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286581000",
                    display: "Vitamin B2 intake (observable entity)", // Riboflavin is a synonym for Vitamin B2
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
                    value: 1.3.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietarySelenium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietarySelenium),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 55)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286616008",
                    display: "Selenium intake (observable entity)",
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
                    value: 55.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietarySugar() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietarySugar),
            quantity: HKQuantity(unit: .gram(), doubleValue: 30)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "226459004",
                    display: "Sugar intake (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "g",
                    system: "http://unitsofmeasure.org",
                    unit: "g",
                    value: 30.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryThiamin() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryThiamin),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1.2)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286579002",
                    display: "Vitamin B1 intake (observable entity)",
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
                    value: 1.2.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryVitaminA() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminA),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 900)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286604002",
                    display: "Vitamin A intake (observable entity)",
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
                    value: 900.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryVitaminB12() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminB12),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 2.4)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "1144896002",
                    display: "Vitamin B12 and/or vitamin B12 derivative intake (observable entity)",
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
                    value: 2.4.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryVitaminB6() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminB6),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1.5)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "1144810007",
                    display: "Vitamin B6 and/or vitamin B6 derivative intake (observable entity)",
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
                    value: 1.5.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryVitaminC() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminC),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 90)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286586005",
                    display: "Vitamin C intake (observable entity)",
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
                    value: 90.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryVitaminD() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminD),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 20)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286607009",
                    display: "Vitamin D intake (observable entity)",
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
                    value: 20.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryVitaminE() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminE),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 15)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286606000",
                    display: "Vitamin E intake (observable entity)",
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
                    value: 15.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryVitaminK() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminK),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 15)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "430195004",
                    display: "Vitamin K intake (observable entity)",
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
                    value: 15.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryWater() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryWater),
            quantity: HKQuantity(unit: .liter(), doubleValue: 2)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "226354008",
                    display: "Water intake (observable entity)",
                    system: .snomedCT
                )
            ]
        )

        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "l",
                    system: "http://unitsofmeasure.org",
                    unit: "l",
                    value: 2.asFHIRDecimalPrimitive()
                )
            )
        )
    }

    func testDietaryZinc() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryZinc),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 11)
        )

        XCTAssertEqual(
            observation.code.coding,
            [
                createCoding(
                    code: "286617004",
                    display: "Zinc intake (observable entity)",
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
                    value: 11.asFHIRDecimalPrimitive()
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
                type: HKQuantityType(.nikeFuel),
                quantity: HKQuantity(unit: .count(), doubleValue: 1)
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
        let nikeFuel = HKQuantitySample(
            type: HKQuantityType(.nikeFuel),
            quantity: HKQuantity(unit: .count(), doubleValue: 1),
            start: try startDate,
            end: try endDate
        )

        let correlation = HKCorrelation(
            type: HKCorrelationType(.bloodPressure),
            start: try startDate,
            end: try endDate,
            objects: [nikeFuel]
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
            type: HKQuantityType(.nikeFuel),
            quantity: HKQuantity(unit: .count(), doubleValue: 1),
            start: try startDate,
            end: try endDate
        )

        XCTAssertEqual(sample.quantityType.codes, [])
    }
}
