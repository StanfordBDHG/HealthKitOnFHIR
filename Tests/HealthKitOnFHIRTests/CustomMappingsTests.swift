//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import HealthKitOnFHIR
import XCTest


final class CustomMappingsTests: XCTestCase {
    func testCustomMappingsTests() throws {
        // swiftlint:disable:previous function_body_length
        // We disable the function body length as this is a test case
        
        let quantitySample = HKQuantitySample(
            type: HKQuantityType(.bodyMass),
            quantity: HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 60),
            start: Date(),
            end: Date()
        )

        guard let ucumSystem = URL(string: "http://unitsofmeasure.org"),
              let stanfordURL = URL(string: "http://stanford.edu") else {
            XCTFail("Could not create URLs")
            return
        }

        var customMapping = [
            HKQuantityType(.bodyMass):
            HKQuantitySampleMapping(
                codings: [
                    MappedCode(
                        code: "SU-01",
                        display: "Stanford University",
                        system: stanfordURL
                    )
                ],
                unit: MappedUnit(
                    hkunit: .ounce(),
                    unit: "oz",
                    system: ucumSystem,
                    code: "[oz_av]"
                )
            )
        ]
        customMapping[HKQuantityType(.bodyMass)]?.unit.removeSystemAndCode()
        XCTAssertNil(customMapping[HKQuantityType(.bodyMass)]?.unit.system)
        XCTAssertNil(customMapping[HKQuantityType(.bodyMass)]?.unit.code)
        
        customMapping[HKQuantityType(.bodyMass)]?.unit.update(system: ucumSystem, code: "[oz_av]")
        XCTAssertEqual(customMapping[HKQuantityType(.bodyMass)]?.unit.system, ucumSystem)
        XCTAssertEqual(customMapping[HKQuantityType(.bodyMass)]?.unit.code, "[oz_av]")

        let hkSampleMapping = HKSampleMapping(quantitySampleMapping: customMapping)
        
        let observation = try quantitySample.observation(
            withMapping: hkSampleMapping
        )
        
        XCTAssertEqual(
            quantitySample.quantityType.codes,
            [
                Coding(
                    code: "29463-7",
                    display: "Body weight",
                    system: FHIRPrimitive(FHIRURI(stringLiteral: "http://loinc.org"))
                ),
                Coding(
                    code: "HKQuantityTypeIdentifierBodyMass",
                    display: "Body Mass",
                    system: FHIRPrimitive(FHIRURI(stringLiteral: "http://developer.apple.com/documentation/healthkit"))
                )
            ]
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                Coding(
                    code: "SU-01",
                    display: "Stanford University",
                    system: FHIRPrimitive(FHIRURI(stanfordURL))
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    code: "[oz_av]",
                    system: "http://unitsofmeasure.org",
                    unit: "oz",
                    value: 2116.43771697482496.asFHIRDecimalPrimitive()
                )
            )
        )
    }
}
