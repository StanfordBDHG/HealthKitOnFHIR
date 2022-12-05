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

        let customMapping = [
            "HKQuantityTypeIdentifierBodyMass":
            HKQuantitySampleMapping(
                codes: [
                    MappedCode(
                        code: "SU-01",
                        display: "Stanford University",
                        system: "http://stanford.edu"
                    )
                ],
                unit: MappedUnit(
                    hkunit: "oz",
                    unitAlias: "ounces"
                )
            )
        ]

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
                )
            ]
        )
        
        XCTAssertEqual(
            observation.code.coding,
            [
                Coding(
                    code: "SU-01",
                    display: "Stanford University",
                    system: FHIRPrimitive(FHIRURI(stringLiteral: "http://stanford.edu"))
                )
            ]
        )
        
        XCTAssertEqual(
            observation.value,
            .quantity(
                Quantity(
                    unit: "ounces",
                    value: 2116.43771697482496.asFHIRDecimalPrimitive()
                )
            )
        )
    }
}
