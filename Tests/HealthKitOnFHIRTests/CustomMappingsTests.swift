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
        let quantitySample = HKQuantitySample(
            type: HKQuantityType(.bodyMass),
            quantity: HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 60),
            start: Date(),
            end: Date()
        )
        
        let observation = try quantitySample.observation(
            withMapping: [
                "HKQuantityTypeIdentifierBodyMass":
                HKQuanitySampleMapping(
                    codes: [
                        HKQuanitySampleMapping.MappedCode(
                            code: "SU-01",
                            display: "Stanford University",
                            system: "http://stanford.edu"
                        )
                    ],
                    unit: HKQuanitySampleMapping.Unit(
                        hkunit: "oz",
                        unitAlias: "ounces"
                    )
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