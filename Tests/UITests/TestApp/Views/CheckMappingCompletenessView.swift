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
        var missingQuantityTypes: Set<String> = []
        var missingCategoryTypes: Set<String> = []
        var missingCorrelationTypes: Set<String> = []
        
        var isEmpty: Bool {
            missingQuantityTypes.isEmpty && missingCategoryTypes.isEmpty && missingCorrelationTypes.isEmpty
        }
    }
    
    
    var body: some View {
        Form {
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
    private func makeSection(title: String, for types: some Collection<String>) -> some View {
        if !types.isEmpty {
            Section(title) {
                ForEach(types.sorted(), id: \.self) { type in
                    Text(type)
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
            result.missingQuantityTypes.insert(type.identifier)
        }
        for type in HKCategoryType.allKnownCategories {
            guard mappings.categorySampleMapping[type] == nil else {
                continue
            }
            result.missingCategoryTypes.insert(type.identifier)
        }
        for type in HKCorrelationType.allKnownCorrelations {
            guard mappings.correlationMapping[type] == nil else {
                continue
            }
            result.missingCorrelationTypes.insert(type.identifier)
        }
        return result
    }
}
