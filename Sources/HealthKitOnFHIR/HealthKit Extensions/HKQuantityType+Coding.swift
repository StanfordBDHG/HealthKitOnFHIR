//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKit
import ModelsR4


extension HKQuantityType {
    /// Converts an HKQuantityType into corresponding FHIR Coding(s) based on a specified mapping
    var codes: [Coding] {
        codes()
    }
    
    
    /// Converts an HKQuantityType into corresponding FHIR Coding(s) based on a specified mapping
    func codes(mappings: [String: HKQuantitySampleMapping] = HKQuantitySampleMapping.default) -> [Coding] {
        guard let mapping = mappings[self.identifier] else {
            return []
        }
        
        return mapping.codes.map {
            Coding(
                code: $0.code.asFHIRStringPrimitive(),
                display: $0.display.asFHIRStringPrimitive(),
                system: FHIRPrimitive(FHIRURI(stringLiteral: $0.system))
            )
        }
    }
}
