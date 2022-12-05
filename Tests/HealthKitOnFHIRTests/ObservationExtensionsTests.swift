//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import HealthKitOnFHIR
import XCTest


final class ObservationExtensionsTests: XCTestCase {
    func testCollectionExtensionsIdentifier() throws {
        // swiftlint:disable:previous function_body_length
        // We disable the function body length as this is a test case
        let observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.appendIdentifier(
            Identifier(id: "ID1")
        )
        
        // Assertions for the nil/non-present case:
        XCTAssertEqual(
            observation.identifier?.first,
            Identifier(id: "ID1")
        )
        
        
        // Now Append multiple elements and in a non-nil collection:
        observation.appendIdentifiers(
            [
                Identifier(id: "ID2"),
                Identifier(id: "ID3")
            ]
        )
        
        // Assertions for the non-nil collection case:
        XCTAssertEqual(
            observation.identifier,
            [
                Identifier(id: "ID1"),
                Identifier(id: "ID2"),
                Identifier(id: "ID3")
            ]
        )
    }
    
    func testCollectionExtensionsCoding() throws {
        // swiftlint:disable:previous function_body_length
        // We disable the function body length as this is a test case
        let observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.appendCoding(
            Coding(
                code: "Code1",
                display: "Display1",
                system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test1.system"))
            )
        )
        
        // Assertions for the nil/non-present case:
        XCTAssertEqual(
            observation.code.coding?.first,
            Coding(
                code: "Code1",
                display: "Display1",
                system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test1.system"))
            )
        )
        
        
        // Now Append multiple elements and in a non-nil collection:
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
        
        // Assertions for the non-nil collection case:
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
    }
    
    func testCollectionExtensionsCategories() throws {
        // swiftlint:disable:previous function_body_length
        // We disable the function body length as this is a test case
        let observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.appendCategory(
            CodeableConcept(id: "Concept1")
        )
        
        // Assertions for the nil/non-present case:
        XCTAssertEqual(
            observation.category?.first,
            CodeableConcept(id: "Concept1")
        )
        
        // Now Append multiple elements and in a non-nil collection:
        observation.appendCategories(
            [
                CodeableConcept(id: "Concept2"),
                CodeableConcept(id: "Concept3")
            ]
        )

        // Assertions for the non-nil collection case:
        XCTAssertEqual(
            observation.category,
            [
                CodeableConcept(id: "Concept1"),
                CodeableConcept(id: "Concept2"),
                CodeableConcept(id: "Concept3")
            ]
        )
    }
    
    func testCollectionExtensionsComponents() throws {
        // swiftlint:disable:previous function_body_length
        // We disable the function body length as this is a test case
        let observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.appendComponent(
            ObservationComponent(
                code: CodeableConcept(id: "Concept4"),
                value: .boolean(true.asPrimitive())
            )
        )
        
        // Assertions for the nil/non-present case:
        XCTAssertEqual(
            observation.component?.first,
            ObservationComponent(
                code: CodeableConcept(id: "Concept4"),
                value: .boolean(true.asPrimitive())
            )
        )
        
        
        // Now Append multiple elements and in a non-nil collection:
        observation.appendComponents([
            ObservationComponent(
                code: CodeableConcept(id: "Concept5"),
                value: .string("Test".asFHIRStringPrimitive())
            ),
            ObservationComponent(
                code: CodeableConcept(id: "Concept6"),
                value: .integer(10.asFHIRIntegerPrimitive())
            )
        ])
        
        // Assertions for the non-nil collection case:
        XCTAssertEqual(
            observation.component,
            [
                ObservationComponent(
                    code: CodeableConcept(id: "Concept4"),
                    value: .boolean(true.asPrimitive())
                ),
                ObservationComponent(
                    code: CodeableConcept(id: "Concept5"),
                    value: .string("Test".asFHIRStringPrimitive())
                ),
                ObservationComponent(
                    code: CodeableConcept(id: "Concept6"),
                    value: .integer(10.asFHIRIntegerPrimitive())
                )
            ]
        )
    }
}
