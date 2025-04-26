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
import Testing


// swiftlint:disable file_length
// We disable the file length rule as this is a test class
@MainActor // to work around https://github.com/apple/FHIRModels/issues/36
struct HKQuantitySampleTests {
    // swiftlint:disable:previous type_body_length
    // We disable the type body length as this is a test class
    var startDate: Date {
        get throws {
            let dateComponents = DateComponents(year: 1891, month: 10, day: 1, hour: 12, minute: 0, second: 0) // Date Stanford University opened (https://www.stanford.edu/about/history/)
            return try #require(Calendar.current.date(from: dateComponents))
        }
    }
    
    var endDate: Date {
        get throws {
            let dateComponents = DateComponents(year: 1891, month: 10, day: 1, hour: 12, minute: 0, second: 42)
            return try #require(Calendar.current.date(from: dateComponents))
        }
    }
    
    func createObservationFrom(
        type quantityType: HKQuantityType,
        quantity: HKQuantity,
        metadata: [String: Any] = [:]
    ) throws -> Observation {
        let quantitySample = HKQuantitySample(
            type: quantityType,
            quantity: quantity,
            start: try startDate,
            end: try endDate,
            metadata: metadata
        )
        return try #require(quantitySample.resource().get(if: Observation.self))
    }
    
    func createCoding(
        code: String,
        display: String,
        system: SupportedCodeSystem
    ) -> Coding {
        Coding(
            code: FHIRPrimitive(stringLiteral: code),
            display: FHIRPrimitive(stringLiteral: display),
            system: FHIRPrimitive(FHIRURI(stringLiteral: system.rawValue))
        )
    }
    
    @Test
    func bloodGlucose() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bloodGlucose),
            quantity: HKQuantity(unit: HKUnit(from: "mg/dL"), doubleValue: 99)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "41653-7",
                display: "Glucose Glucometer (BldC) [Mass/Vol]",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierBloodGlucose",
                display: "Blood Glucose",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg/dL",
                system: "http://unitsofmeasure.org",
                unit: "mg/dL",
                value: 99.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryBiotin() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryBiotin),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryBiotin",
                display: "Dietary Biotin",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryCaffeine() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryCaffeine),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryCaffeine",
                display: "Dietary Caffeine",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryCalcium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryCalcium),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1000)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryCalcium",
                display: "Dietary Calcium",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 1000.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryCarbohydrates() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryCarbohydrates),
            quantity: HKQuantity(unit: .gram(), doubleValue: 1000)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryCarbohydates",
                display: "Dietary Carbohydates",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "g",
                system: "http://unitsofmeasure.org",
                unit: "g",
                value: 1000.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryChloride() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryChloride),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 2300)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryChloride",
                display: "Dietary Chloride",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 2300.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryCholesterol() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryCholesterol),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryCholesterol",
                display: "Dietary Cholesterol",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryChromium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryChromium),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 25)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryChromium",
                display: "Dietary Chromium",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 25.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryCopper() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryCopper),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 900)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryCopper",
                display: "Dietary Copper",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 900.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryFatMonounsaturated() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFatMonounsaturated),
            quantity: HKQuantity(unit: .gram(), doubleValue: 22)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryFatMonounsaturated",
                display: "Dietary Fat Monounsaturated",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "g",
                system: "http://unitsofmeasure.org",
                unit: "g",
                value: 22.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryFatPolyunsaturated() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFatPolyunsaturated),
            quantity: HKQuantity(unit: .gram(), doubleValue: 30)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryFatPolyunsaturated",
                display: "Dietary Fat Polyunsaturated",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "g",
                system: "http://unitsofmeasure.org",
                unit: "g",
                value: 30.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryFatSaturated() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFatSaturated),
            quantity: HKQuantity(unit: .gram(), doubleValue: 30)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryFatSaturated",
                display: "Dietary Fat Saturated",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "g",
                system: "http://unitsofmeasure.org",
                unit: "g",
                value: 30.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryFatTotal() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFatTotal),
            quantity: HKQuantity(unit: .gram(), doubleValue: 66)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryFatTotal",
                display: "Dietary Fat Total",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "g",
                system: "http://unitsofmeasure.org",
                unit: "g",
                value: 66.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryFiber() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFiber),
            quantity: HKQuantity(unit: .gram(), doubleValue: 30)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "LP203183-1",
                display: "Fiber intake",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryFiber",
                display: "Dietary Fiber",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "g",
                system: "http://unitsofmeasure.org",
                unit: "g",
                value: 30.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryFolate() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryFolate),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 400)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryFolate",
                display: "Dietary Folate",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 400.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryIodine() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryIodine),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 140)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryIodine",
                display: "Dietary Iodine",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 140.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryIron() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryIron),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 16)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryIron",
                display: "Dietary Iron",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 16.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryMagnesium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryMagnesium),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 400)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryMagnesium",
                display: "Dietary Magnesium",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 400.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryManganese() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryManganese),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 2.3)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryManganese",
                display: "Dietary Manganese",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 2.3.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryMolybdenum() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryMolybdenum),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 45)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryMolybdenum",
                display: "Dietary Molybdenum",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 45.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryPhosphorus() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryPhosphorus),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1000)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryPhosphorus",
                display: "Dietary Phosphorus",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 1000.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryPotassium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryPotassium),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1000)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryPotassium",
                display: "Dietary Potassium",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 1000.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietarySodium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietarySodium),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1000)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietarySodium",
                display: "Dietary Sodium",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 1000.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryNiacin() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryNiacin),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 16)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryNiacin",
                display: "Dietary Niacin",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 16.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryPantothenicAcid() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryPantothenicAcid),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 5)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryPantothenicAcid",
                display: "Dietary Pantothenic Acid",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 5.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryProtein() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryProtein),
            quantity: HKQuantity(unit: .gram(), doubleValue: 40)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryProtein",
                display: "Dietary Protein",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "g",
                system: "http://unitsofmeasure.org",
                unit: "g",
                value: 40.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryRiboflavin() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryRiboflavin),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1.3)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryRiboflavin",
                display: "Dietary Riboflavin",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 1.3.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietarySelenium() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietarySelenium),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 55)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietarySelenium",
                display: "Dietary Selenium",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 55.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietarySugar() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietarySugar),
            quantity: HKQuantity(unit: .gram(), doubleValue: 30)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietarySugar",
                display: "Dietary Sugar",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "g",
                system: "http://unitsofmeasure.org",
                unit: "g",
                value: 30.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryThiamin() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryThiamin),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1.2)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryThiamin",
                display: "Dietary Thiamin",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 1.2.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryVitaminA() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminA),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 900)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryVitaminA",
                display: "Dietary Vitamin A",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 900.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryVitaminB12() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminB12),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 2.4)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryVitaminB12",
                display: "Dietary Vitamin B12",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 2.4.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryVitaminB6() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminB6),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 1.5)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryVitaminB6",
                display: "Dietary Vitamin B6",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 1.5.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryVitaminC() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminC),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 90)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryVitaminC",
                display: "Dietary Vitamin C",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 90.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryVitaminD() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminD),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 20)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryVitaminD",
                display: "Dietary Vitamin D",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 20.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryVitaminE() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminE),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 15)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryVitaminE",
                display: "Dietary Vitamin E",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 15.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryVitaminK() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryVitaminK),
            quantity: HKQuantity(unit: .gramUnit(with: .micro), doubleValue: 15)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryVitaminK",
                display: "Dietary Vitamin K",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ug",
                system: "http://unitsofmeasure.org",
                unit: "ug",
                value: 15.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryWater() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryWater),
            quantity: HKQuantity(unit: .liter(), doubleValue: 2)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryWater",
                display: "Dietary Water",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "l",
                system: "http://unitsofmeasure.org",
                unit: "l",
                value: 2.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @Test
    func dietaryZinc() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.dietaryZinc),
            quantity: HKQuantity(unit: .gramUnit(with: .milli), doubleValue: 11)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDietaryZinc",
                display: "Dietary Zinc",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mg",
                system: "http://unitsofmeasure.org",
                unit: "mg",
                value: 11.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testElectrodermalActivity() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.electrodermalActivity),
            quantity: HKQuantity(unit: .siemen(), doubleValue: 0.000001)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierElectrodermalActivity",
                display: "Electrodermal Activity",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "S",
                system: "http://unitsofmeasure.org",
                unit: "siemens",
                value: 0.000001.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testForcedExpiratoryVolume1() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.forcedExpiratoryVolume1),
            quantity: HKQuantity(unit: .liter(), doubleValue: 3.5)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "20150-9",
                display: "FEV1",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierForcedExpiratoryVolume1",
                display: "Forced Expiratory Volume 1",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "L",
                system: "http://unitsofmeasure.org",
                unit: "L",
                value: 3.5.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testForcedVitalCapacity() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.forcedVitalCapacity),
            quantity: HKQuantity(unit: .liter(), doubleValue: 5.5)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "19870-5",
                display: "Forced vital capacity [Volume] Respiratory system",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierForcedVitalCapacity",
                display: "Forced Vital Capacity",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "L",
                system: "http://unitsofmeasure.org",
                unit: "L",
                value: 5.5.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testInhalerUsage() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.inhalerUsage),
            quantity: HKQuantity(unit: .count(), doubleValue: 3)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierInhalerUsage",
                display: "Inhaler Usage",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                unit: "count",
                value: 3.asFHIRDecimalPrimitive()
            )
        ))
    }

    func testStepCount() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.stepCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 42)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "55423-8",
                display: "Number of steps in unspecified time Pedometer",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierStepCount",
                display: "Step Count",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                unit: "steps",
                value: 42.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testFlightsClimbed() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.flightsClimbed),
            quantity: HKQuantity(unit: .count(), doubleValue: 10)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "100304-5",
                display: "Flights climbed [#] Reporting Period",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierFlightsClimbed",
                display: "Flights Climbed",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                unit: "flights",
                value: 10.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testHeartRate() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.heartRate),
            quantity: HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 84)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "8867-4",
                display: "Heart rate",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierHeartRate",
                display: "Heart Rate",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "/min",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "beats/minute",
                value: 84.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testRestingHeartRate() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.restingHeartRate),
            quantity: HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 84)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "40443-4",
                display: "Heart rate --resting",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierRestingHeartRate",
                display: "Resting Heart Rate",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "/min",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "beats/minute",
                value: 84.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testWalkingHeartRateAverage() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.walkingHeartRateAverage),
            quantity: HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 84)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierWalkingHeartRateAverage",
                display: "Walking Heart Rate Average",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "/min",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "beats/minute",
                value: 84.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testWalkingAsymmetryPercentage() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.walkingAsymmetryPercentage),
            quantity: HKQuantity(unit: .percent(), doubleValue: 50)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierWalkingAsymmetryPercentage",
                display: "Walking Asymmetry Percentage",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "%",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "%",
                value: 50.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testWalkingSpeed() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.walkingSpeed),
            quantity: HKQuantity(unit: HKUnit.meter().unitDivided(by: HKUnit.second()), doubleValue: 1.5)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierWalkingSpeed",
                display: "Walking Speed",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "m/s",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "m/s",
                value: 1.5.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testHeartRateVariabilitySDNN() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.heartRateVariabilitySDNN),
            quantity: HKQuantity(unit: .secondUnit(with: .milli), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "80404-7",
                display: "R-R interval.standard deviation (Heart rate variability)",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierHeartRateVariabilitySDNN",
                display: "Heart Rate Variability SDNN",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "ms",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "ms",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testOxygenSaturation() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.oxygenSaturation),
            quantity: HKQuantity(unit: .percent(), doubleValue: 99)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "59408-5",
                display: "Oxygen saturation in Arterial blood by Pulse oximetry",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierOxygenSaturation",
                display: "Oxygen Saturation",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "%",
                system: "http://unitsofmeasure.org",
                unit: "%",
                value: 99.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testPeakExpiratoryFlowRate() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.peakExpiratoryFlowRate),
            quantity: HKQuantity(unit: .liter().unitDivided(by: .minute()), doubleValue: 600)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "19935-6",
                display: "Maximum expiratory gas flow Respiratory system airway by Peak flow meter",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierPeakExpiratoryFlowRate",
                display: "Peak Expiratory Flow Rate",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "L/min",
                system: "http://unitsofmeasure.org",
                unit: "L/min",
                value: 600.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testPeripheralPerfusionIndex() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.peripheralPerfusionIndex),
            quantity: HKQuantity(unit: .percent(), doubleValue: 5)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "61006-3",
                display: "Perfusion index Tissue by Pulse oximetry",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierPeripheralPerfusionIndex",
                display: "Peripheral Perfusion Index",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "%",
                system: "http://unitsofmeasure.org",
                unit: "%",
                value: 5.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testPushCount() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.pushCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 5)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "96502-0",
                display: "Number of wheelchair pushes per time period",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierPushCount",
                display: "Push Count",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                unit: "wheelchair pushes",
                value: 5.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
    func testTimeInDaylight() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.timeInDaylight),
            quantity: HKQuantity(unit: .minute(), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierTimeInDaylight",
                display: "Time in Daylight",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "min",
                system: "http://unitsofmeasure.org",
                unit: "min",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testUVExposure() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.uvExposure),
            quantity: HKQuantity(unit: .count(), doubleValue: 5)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierUVExposure",
                display: "UV Exposure",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                unit: "count",
                value: 5.asFHIRDecimalPrimitive()
            )
        ))
    }

    func testVO2Max() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.vo2Max),
            quantity: HKQuantity(unit: HKUnit(from: "mL/kg*min"), doubleValue: 31)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierVO2Max",
                display: "VO2 Max",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "mL/kg/min",
                system: "http://unitsofmeasure.org",
                unit: "mL/kg/min",
                value: 31.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testWaistCircumference() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.waistCircumference),
            quantity: HKQuantity(unit: HKUnit(from: "in"), doubleValue: 38.7)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "8280-0",
                display: "Waist Circumference at umbilicus by Tape measure",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierWaistCircumference",
                display: "Waist Circumference",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "in",
                system: "http://unitsofmeasure.org",
                unit: "in",
                value: 38.7.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testBodyTemperature() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bodyTemperature),
            quantity: HKQuantity(unit: .degreeCelsius(), doubleValue: 37)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "8310-5",
                display: "Body temperature",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierBodyTemperature",
                display: "Body Temperature",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "Cel",
                system: "http://unitsofmeasure.org",
                unit: "C",
                value: 37.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testBasalBodyTemperature() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.basalBodyTemperature),
            quantity: HKQuantity(unit: .degreeCelsius(), doubleValue: 37)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierBasalBodyTemperature",
                display: "Basal Body Temperature",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "Cel",
                system: "http://unitsofmeasure.org",
                unit: "C",
                value: 37.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testBasalEnergyBurned() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.basalEnergyBurned),
            quantity: HKQuantity(unit: HKUnit(from: "kcal"), doubleValue: 1200)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierBasalEnergyBurned",
                display: "Basal energy burned",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "kcal",
                system: "http://unitsofmeasure.org",
                unit: "kcal",
                value: 1200.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testBloodAlcoholContent() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bloodAlcoholContent),
            quantity: HKQuantity(unit: .percent(), doubleValue: 0.0)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "74859-0",
                display: "Ethanol [Mass/volume] in Blood Estimated from serum or plasma level",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierBloodAlcoholContent",
                display: "Blood Alcohol Content",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "%",
                system: "http://unitsofmeasure.org",
                unit: "%",
                value: 0.0.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testBodyFatPercentage() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bodyFatPercentage),
            quantity: HKQuantity(unit: .percent(), doubleValue: 21)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "41982-0",
                display: "Percentage of body fat Measured",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierBodyFatPercentage",
                display: "Body Fat Percentage",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "%",
                system: "http://unitsofmeasure.org",
                unit: "%",
                value: 21.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testBodyMassIndex() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bodyMassIndex),
            quantity: HKQuantity(unit: .count(), doubleValue: 20)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "39156-5",
                display: "Body mass index (BMI) [Ratio]",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierBodyMassIndex",
                display: "Body Mass Index",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "kg/m2",
                system: "http://unitsofmeasure.org",
                unit: "kg/m^2",
                value: 20.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testHeight() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.height),
            quantity: HKQuantity(unit: .inch(), doubleValue: 64)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "8302-2",
                display: "Body height",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierHeight",
                display: "Height",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "[in_i]",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "in",
                value: 64.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testBodyMass() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.bodyMass),
            quantity: HKQuantity(unit: .pound(), doubleValue: 60)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "29463-7",
                display: "Body weight",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierBodyMass",
                display: "Body Mass",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "[lb_av]",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "lbs",
                value: 60.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testLeanBodyMass() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.leanBodyMass),
            quantity: HKQuantity(unit: .pound(), doubleValue: 60)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "91557-9",
                display: "Lean body weight",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierLeanBodyMass",
                display: "Lean Body Mass",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "[lb_av]",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "lbs",
                value: 60.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testNumberOfTimesFallen() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.numberOfTimesFallen),
            quantity: HKQuantity(unit: .count(), doubleValue: 0)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierNumberOfTimesFallen",
                display: "Number Of Times Fallen",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                unit: "falls",
                value: 0.asFHIRDecimalPrimitive()
            )
        ))
    }

    func testSwimmingStrokeCount() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.swimmingStrokeCount),
            quantity: HKQuantity(unit: .count(), doubleValue: 10)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierSwimmingStrokeCount",
                display: "Swimming Stroke Count",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                unit: "strokes",
                value: 10.asFHIRDecimalPrimitive()
            )
        ))
    }

    func testRespiratoryRate() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.respiratoryRate),
            quantity: HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 18)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "9279-1",
                display: "Respiratory rate",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierRespiratoryRate",
                display: "Respiratory Rate",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "/min",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "breaths/minute",
                value: 18.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testActiveEnergyBurned() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.activeEnergyBurned),
            quantity: HKQuantity(unit: .largeCalorie(), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "41981-2",
                display: "Calories burned",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierActiveEnergyBurned",
                display: "Active Energy Burned",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "kcal",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "kcal",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testAppleExerciseTime() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.appleExerciseTime),
            quantity: HKQuantity(unit: .minute(), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierAppleExerciseTime",
                display: "Apple Exercise Time",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "min",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "min",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testAppleMoveTime() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.appleMoveTime),
            quantity: HKQuantity(unit: .minute(), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierAppleMoveTime",
                display: "Apple Move Time",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "min",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "min",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    @available(iOS 17.0, macOS 14.0, watchOS 10.0, *)
    func testApplePhysicalEffort() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.physicalEffort),
            quantity: HKQuantity(unit: HKUnit(from: "kcal/hr*kg"), doubleValue: 2)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierPhysicalEffort",
                display: "Apple Physical Effort",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "kcal/hr/kg",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "kcal/hr/kg",
                value: 2.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testAppleStandTime() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.appleStandTime),
            quantity: HKQuantity(unit: .minute(), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierAppleStandTime",
                display: "Apple Stand Time",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "min",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "min",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testAppleWalkingSteadiness() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.appleWalkingSteadiness),
            quantity: HKQuantity(unit: .percent(), doubleValue: 50)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierAppleWalkingSteadiness",
                display: "Apple Walking Steadiness",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "%",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "%",
                value: 50.asFHIRDecimalPrimitive()
            )
        ))
    }

    func testDistanceCycling() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.distanceCycling),
            quantity: HKQuantity(unit: .meter(), doubleValue: 1000)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDistanceCycling",
                display: "Distance Cycling",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "m",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "m",
                value: 1000.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testDistanceDownhillSnowSports() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.distanceDownhillSnowSports),
            quantity: HKQuantity(unit: .meter(), doubleValue: 1000)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDistanceDownhillSnowSports",
                display: "Distance Downhill Snow Sports",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "m",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "m",
                value: 1000.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testDistanceSwimming() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.distanceSwimming),
            quantity: HKQuantity(unit: .meter(), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "93816-7",
                display: "Swimming distance unspecified time",
                system: .loinc
            ),
            createCoding(
                code: "HKQuantityTypeIdentifierDistanceSwimming",
                display: "Distance Swimming",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "m",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "m",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }

    
    func testDistanceWalkingRunning() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.distanceWalkingRunning),
            quantity: HKQuantity(unit: .meter(), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDistanceWalkingRunning",
                display: "Distance Walking or Running",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "m",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "m",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testDistanceWheelchair() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.distanceWheelchair),
            quantity: HKQuantity(unit: .meter(), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierDistanceWheelchair",
                display: "Distance in a Wheelchair",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "m",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "m",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testEnvironmentalAudioExposure() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.environmentalAudioExposure),
            quantity: HKQuantity(unit: .decibelAWeightedSoundPressureLevel(), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierEnvironmentalAudioExposure",
                display: "Environmental Audio Exposure",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "dB(SPL)",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "dB(SPL)",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testHeadphoneAudioExposure() throws {
        let observation = try createObservationFrom(
            type: HKQuantityType(.headphoneAudioExposure),
            quantity: HKQuantity(unit: .decibelAWeightedSoundPressureLevel(), doubleValue: 100)
        )
        #expect(observation.code.coding == [
            createCoding(
                code: "HKQuantityTypeIdentifierHeadphoneAudioExposure",
                display: "Headphone Audio Exposure",
                system: .apple
            )
        ])
        #expect(observation.value == .quantity(
            Quantity(
                code: "dB(SPL)",
                system: "http://unitsofmeasure.org".asFHIRURIPrimitive(),
                unit: "dB(SPL)",
                value: 100.asFHIRDecimalPrimitive()
            )
        ))
    }
    
    func testUnsupportedTypeSample() throws {
        let quantitySample = HKQuantitySample(
            type: HKQuantityType(.nikeFuel),
            quantity: HKQuantity(unit: .count(), doubleValue: 1),
            start: try startDate,
            end: try endDate
        )
        #expect(throws: HealthKitOnFHIRError.self) {
            try quantitySample.resource().get(if: Observation.self)
        }
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
        #expect(throws: HealthKitOnFHIRError.self) {
            try correlation.resource()
        }
    }
    
    func testUnsupportedType() throws {#expect(throws: HealthKitOnFHIRError.self) {
            try HKVisionPrescription(
                type: .glasses,
                dateIssued: try startDate,
                expirationDate: nil,
                device: nil,
                metadata: nil
            ).resource()
        }
    }
    
    func testUnsupportedMapping() throws {
        let sample = HKQuantitySample(
            type: HKQuantityType(.nikeFuel),
            quantity: HKQuantity(unit: .count(), doubleValue: 1),
            start: try startDate,
            end: try endDate
        )
        #expect(sample.quantityType.codes.isEmpty)
    }
    
    func testCollectionSampleToResourceProxy() throws {
        func makeSample(numSteps: Int, date: DateComponents) throws -> HKQuantitySample {
            let date = try #require(Calendar.current.date(from: date))
            return HKQuantitySample(
                type: HKQuantityType(.stepCount),
                quantity: HKQuantity(unit: .count(), doubleValue: Double(numSteps)),
                start: date,
                end: date
            )
        }
        let samples = [
            try makeSample(numSteps: 12, date: .init(year: 2025, month: 1, day: 1, hour: 0)),
            try makeSample(numSteps: 13, date: .init(year: 2025, month: 1, day: 1, hour: 1)),
            try makeSample(numSteps: 14, date: .init(year: 2025, month: 1, day: 1, hour: 2)),
            try makeSample(numSteps: 15, date: .init(year: 2025, month: 1, day: 1, hour: 3)),
            try makeSample(numSteps: 16, date: .init(year: 2025, month: 1, day: 1, hour: 4)),
            try makeSample(numSteps: 17, date: .init(year: 2025, month: 1, day: 1, hour: 5))
        ]
        let resources = try samples.mapIntoResourceProxies()
        #expect(resources.count == samples.count)
        for resource in resources {
            #expect(resource.get(if: Observation.self) != nil)
        }
    }
    
    func testCollectionSampleToResourceProxyWithUnsupportedSample() throws {
        func makeSample(numSteps: Int, date: DateComponents) throws -> HKQuantitySample {
            let date = try #require(Calendar.current.date(from: date))
            return HKQuantitySample(
                type: HKQuantityType(.stepCount),
                quantity: HKQuantity(unit: .count(), doubleValue: Double(numSteps)),
                start: date,
                end: date
            )
        }
        let samples = [
            try makeSample(numSteps: 12, date: .init(year: 2025, month: 1, day: 1, hour: 0)),
            try makeSample(numSteps: 13, date: .init(year: 2025, month: 1, day: 1, hour: 1)),
            try makeSample(numSteps: 14, date: .init(year: 2025, month: 1, day: 1, hour: 2)),
            try makeSample(numSteps: 15, date: .init(year: 2025, month: 1, day: 1, hour: 3)),
            try makeSample(numSteps: 16, date: .init(year: 2025, month: 1, day: 1, hour: 4)),
            try makeSample(numSteps: 17, date: .init(year: 2025, month: 1, day: 1, hour: 5)),
            HKQuantitySample(type: HKQuantityType(.nikeFuel), quantity: HKQuantity(unit: .count(), doubleValue: 123), start: .now, end: .now)
        ]
        #expect(throws: HealthKitOnFHIRError.self) {
            try samples.mapIntoResourceProxies()
        }
        let resources = try samples.compactMapIntoResourceProxies()
        #expect(resources.count == samples.count - 1)
        for resource in resources {
            #expect(resource.get(if: Observation.self) != nil)
        }
    }
}
