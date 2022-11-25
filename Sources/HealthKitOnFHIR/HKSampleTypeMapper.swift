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

extension HKSampleType {
    struct HKSampleTypeCodeMapping: Codable {
        let hktype: String
        let codes: [MappedCode]

        static let allMappings: [HKSampleTypeCodeMapping] = Bundle.module.decode(file: "mapping.json")
    }

    struct MappedCode: Codable {
        let code, display: String
        let system: String
    }

    func convertToCodes() -> [Coding] {
        guard let mapping = HKSampleTypeCodeMapping.allMappings.first(where: { $0.hktype == self.identifier }) else {
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
