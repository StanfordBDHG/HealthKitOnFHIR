//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import XCTest
@testable import HealthKitOnFHIR


final class ObservationExtensionsTests: XCTestCase {
    func testCollectionExtensions() throws {
        let observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        observation.appendIdentifier(
            Identifier(id: "ID1")
        )
        observation.appendCoding(
            Coding(
                code: "Code1",
                display: "Display1",
                system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test1.system"))
            )
        )
        observation.appendCategory(
            CodeableConcept(id: "Concept1")
        )
        
        XCTAssertEqual(
            observation.identifier?.first,
            Identifier(id: "ID1")
        )
        XCTAssertEqual(
            observation.code.coding?.first,
            Coding(
                code: "Code1",
                display: "Display1",
                system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test1.system"))
            )
        )
        XCTAssertEqual(
            observation.category?.first,
            CodeableConcept(id: "Concept1")
        )
        
        // Append multiple elements and in a non-nil collection:
        
        observation.appendIdentifiers(
            [
                Identifier(id: "ID2"),
                Identifier(id: "ID3")
            ]
        )
        observation.appendCodings(
            [
                Coding(
                    code: "Code2",
                    display: "Display2",
                    system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test2.system"))
                ),
                Coding(
                    code: "Code3",
                    display: "Display3",
                    system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test3.system"))
                )
            ]
        )
        observation.appendCategories(
            [
                CodeableConcept(id: "Concept2"),
                CodeableConcept(id: "Concept3")
            ]
        )
        
        
        XCTAssertEqual(
            observation.identifier,
            [
                Identifier(id: "ID1"),
                Identifier(id: "ID2"),
                Identifier(id: "ID3")
            ]
        )
        XCTAssertEqual(
            observation.code.coding,
            [
                Coding(
                    code: "Code1",
                    display: "Display1",
                    system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test1.system"))
                ),
                Coding(
                    code: "Code2",
                    display: "Display2",
                    system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test2.system"))
                ),
                Coding(
                    code: "Code3",
                    display: "Display3",
                    system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test3.system"))
                )
            ]
        )
        XCTAssertEqual(
            observation.category,
            [
                CodeableConcept(id: "Concept1"),
                CodeableConcept(id: "Concept2"),
                CodeableConcept(id: "Concept3")
            ]
        )
    }
}
