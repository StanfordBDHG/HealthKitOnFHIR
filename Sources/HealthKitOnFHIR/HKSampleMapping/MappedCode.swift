//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4


/// A ``MappedCode`` instance is used to specify codings for FHIR observations mapped from HealthKit's `HKSample`s.
public struct MappedCode: Decodable {
    /// The identifying code.
    public var code: String
    /// A display value for the code.
    public var display: String
    /// The coding system.
    public var system: String
    
    
    var coding: Coding {
        Coding(
            code: code.asFHIRStringPrimitive(),
            display: display.asFHIRStringPrimitive(),
            system: FHIRPrimitive(FHIRURI(stringLiteral: system))
        )
    }
    
    
    /// A ``MappedCode`` instance is used to specify codings for FHIR observations mapped from HealthKit's `HKSample`s.
    /// - Parameters:
    ///   - code: The identifying code.
    ///   - display: A display value for the code.
    ///   - system: The coding system.
    public init(
        code: String,
        display: String,
        system: String
    ) {
        self.code = code
        self.display = display
        self.system = system
    }
}
