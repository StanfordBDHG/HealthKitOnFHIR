//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKitOnFHIR
import SpeziHealthKit
import SwiftUI


struct CheckMappingCompletenessView: View {
    private struct TestResult {
        struct Entry: Hashable {
            let typeIdentifier: String
            let unitString: String?
        }
        var missingQuantityTypes: Set<Entry> = []
        var missingCategoryTypes: Set<Entry> = []
        var missingCorrelationTypes: Set<Entry> = []
        
        var isEmpty: Bool {
            missingQuantityTypes.isEmpty && missingCategoryTypes.isEmpty && missingCorrelationTypes.isEmpty
        }
    }
    
    
    var body: some View {
        Form {
            let _ = print(SampleType.environmentalSoundReduction.displayUnit.unitString)
            let testResult = runCheck()
            Section {
                Text(testResult.isEmpty ? "All Fine!" : "Missing Mapping Entries!")
            }
            makeSection(title: "Missing Quantity Types", for: testResult.missingQuantityTypes)
            makeSection(title: "Missing Category Types", for: testResult.missingCategoryTypes)
            makeSection(title: "Missing Correlation Types", for: testResult.missingCorrelationTypes)
        }
    }
    
    @ViewBuilder
    private func makeSection(title: String, for types: some Collection<TestResult.Entry>) -> some View {
        if !types.isEmpty {
            Section(title) {
                ForEach(types.sorted(by: { $0.typeIdentifier < $1.typeIdentifier }), id: \.self) { entry in
                    HStack {
                        Text(entry.typeIdentifier)
                        if let unitString = entry.unitString {
                            Spacer()
                            Text(unitString)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .monospaced()
                        }
                    }
                }
            }
        }
    }
    
    private func runCheck() -> TestResult {
        var result = TestResult()
        let mappings = HKSampleMapping.default
        for type in HKQuantityType.allKnownQuantities {
            guard mappings.quantitySampleMapping[type] == nil else {
                continue
            }
            result.missingQuantityTypes.insert(.init(
                typeIdentifier: type.identifier,
                unitString: type.sampleType.flatMap { $0 as? SampleType<HKQuantitySample> }?.displayUnit.unitString
            ))
        }
        for type in HKCategoryType.allKnownCategories {
            guard mappings.categorySampleMapping[type] == nil else {
                continue
            }
            result.missingCategoryTypes.insert(.init(typeIdentifier: type.identifier, unitString: nil))
        }
        for type in HKCorrelationType.allKnownCorrelations {
            guard mappings.correlationMapping[type] == nil else {
                continue
            }
            result.missingCorrelationTypes.insert(.init(typeIdentifier: type.identifier, unitString: nil))
        }
        return result
    }
}
