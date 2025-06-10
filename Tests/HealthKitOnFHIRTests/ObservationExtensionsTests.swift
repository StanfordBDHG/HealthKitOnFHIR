//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@testable import HealthKitOnFHIR
import ModelsR4
import Testing


@MainActor // to work around https://github.com/apple/FHIRModels/issues/36
struct ObservationExtensionsTests {
    @Test
    func testCollectionExtensionsIdentifier() throws {
        let observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.appendIdentifier(Identifier(id: "ID1"))
        
        // Assertions for the nil/non-present case:
        #expect(observation.identifier?.first == Identifier(id: "ID1"))
        
        // Now Append multiple elements and in a non-nil collection:
        observation.appendIdentifiers([
            Identifier(id: "ID2"),
            Identifier(id: "ID3")
        ])
        
        // Assertions for the non-nil collection case:
        #expect(observation.identifier == [
            Identifier(id: "ID1"),
            Identifier(id: "ID2"),
            Identifier(id: "ID3")
        ])
    }
    
    @Test
    func testCollectionExtensionsCoding() throws {
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
        #expect(observation.code.coding?.first == Coding(
            code: "Code1",
            display: "Display1",
            system: FHIRPrimitive(FHIRURI(stringLiteral: "https://test1.system"))
        ))
        
        // Now Append multiple elements and in a non-nil collection:
        observation.appendCodings([
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
        ])
        
        // Assertions for the non-nil collection case:
        #expect(observation.code.coding == [
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
        ])
    }
    
    @Test
    func testCollectionExtensionsCategories() throws {
        let observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.appendCategory(CodeableConcept(id: "Concept1"))
        
        // Assertions for the nil/non-present case:
        #expect(observation.category?.first == CodeableConcept(id: "Concept1"))
        
        // Now Append multiple elements and in a non-nil collection:
        observation.appendCategories([
            CodeableConcept(id: "Concept2"),
            CodeableConcept(id: "Concept3")
        ])

        // Assertions for the non-nil collection case:
        #expect(observation.category == [
            CodeableConcept(id: "Concept1"),
            CodeableConcept(id: "Concept2"),
            CodeableConcept(id: "Concept3")
        ])
    }
    
    @Test
    func testCollectionExtensionsComponents() throws {
        let observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        
        // First test all extensions with no value beeing present (collection is nil)
        observation.appendComponent(
            ObservationComponent(
                code: CodeableConcept(id: "Concept4"),
                value: .boolean(true.asPrimitive())
            )
        )
        
        // Assertions for the nil/non-present case:
        #expect(observation.component?.first == ObservationComponent(
            code: CodeableConcept(id: "Concept4"),
            value: .boolean(true.asPrimitive())
        ))
        
        
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
        #expect(observation.component == [
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
        ])
    }
    
    
    @Test
    func fhirExtension() throws {
        let extension1Url = try #require("https://spezi.stanford.edu/fhir/testDef1".asFHIRURIPrimitive())
        let extension2Url = try #require("https://spezi.stanford.edu/fhir/testDef2".asFHIRURIPrimitive())
        let extension1: (Int) -> Extension = { Extension(url: extension1Url, value: .integer($0.asFHIRIntegerPrimitive())) }
        let extension2: (Int) -> Extension = { Extension(url: extension2Url, value: .integer($0.asFHIRIntegerPrimitive())) }
        
        let observation = Observation(code: CodeableConcept(), status: FHIRPrimitive(.final))
        #expect(observation.extension == nil)
        
        observation.appendExtension(extension1(0), replaceAllExistingWithSameUrl: false)
        #expect(observation.extension == [extension1(0)])
        
        observation.appendExtension(extension2(0), replaceAllExistingWithSameUrl: false)
        #expect(observation.extension == [extension1(0), extension2(0)])
        
        observation.appendExtension(extension1(1), replaceAllExistingWithSameUrl: true)
        #expect(observation.extension == [extension2(0), extension1(1)])
        
        observation.appendExtension(extension1(2), replaceAllExistingWithSameUrl: false)
        #expect(observation.extension == [extension2(0), extension1(1), extension1(2)])
        
        observation.appendExtension(extension1(3), replaceAllExistingWithSameUrl: true)
        #expect(observation.extension == [extension2(0), extension1(3)])
        
        observation.appendExtension(extension2(1), replaceAllExistingWithSameUrl: false)
        #expect(observation.extension == [extension2(0), extension1(3), extension2(1)])
        
        observation.appendExtension(extension2(2), replaceAllExistingWithSameUrl: false)
        #expect(observation.extension == [extension2(0), extension1(3), extension2(1), extension2(2)])
        
        observation.removeFirstExtension(withUrl: extension1Url)
        #expect(observation.extension == [extension2(0), extension2(1), extension2(2)])
        
        observation.removeFirstExtension(withUrl: extension2Url)
        #expect(observation.extension == [extension2(1), extension2(2)])
        
        observation.removeAllExtensions(withUrl: extension2Url)
        #expect(observation.extension == nil)
    }
}
