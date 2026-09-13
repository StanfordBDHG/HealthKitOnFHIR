//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2026 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
@testable import HealthKitOnFHIR
import Testing


/// Consistency checks for the default `HKSampleMapping.json` resource.
struct HKSampleMappingTests {
    private static let healthKitSystem = "http://developer.apple.com/documentation/healthkit"
    
    /// Every coding on the HealthKit code system must use the identifier of the sample type it is defined for.
    ///
    /// The codes are typed by hand in the mapping resource, which makes copy-and-paste mistakes easy; this catches them.
    @Test
    func healthKitCodingsMatchTheirSampleType() {
        let mapping = HKSampleMapping.default
        let entries: [(identifier: String, codings: [MappedCode])] = mapping.quantitySampleMapping.map { ($0.key.identifier, $0.value.codings) }
            + mapping.categorySampleMapping.map { ($0.key.identifier, $0.value.codings) }
            + mapping.correlationMapping.map { ($0.key.identifier, $0.value.codings) }
        #expect(entries.count > 150)
        for entry in entries {
            for coding in entry.codings where coding.system.absoluteString == Self.healthKitSystem {
                #expect(coding.code == entry.identifier, "\(entry.identifier) is mapped to the HealthKit code \(coding.code)")
            }
        }
    }
}
