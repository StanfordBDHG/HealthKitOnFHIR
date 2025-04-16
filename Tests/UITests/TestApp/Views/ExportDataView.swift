//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKit
import HealthKitOnFHIR
import SwiftUI


struct ExportDataView: View {
    private enum ViewState {
        case idle
        case processing
        case failed(any Error)
        
        var isIdle: Bool {
            switch self {
            case .idle:
                true
            case .processing, .failed:
                false
            }
        }
    }
    
    private let healthStore = HKHealthStore()
    
    @State private var viewState: ViewState = .idle
    @State private var generateResourcesDuration: TimeInterval?
    
    var body: some View {
        Form {
            Section("Actions") {
                actionsSectionContent
            }
            if let generateResourcesDuration {
                Section {
                    LabeledContent("genResoueces", value: "\(generateResourcesDuration) sec")
                }
            }
        }
    }
    
    @ViewBuilder private var actionsSectionContent: some View {
        Button("Ask for Authorization") {
            runAsync {
                try await healthStore.requestAuthorization(
                    toShare: [],
                    read: [HKQuantityType(.activeEnergyBurned), HKQuantityType(.stepCount), HKQuantityType(.appleExerciseTime)]
                )
            }
        }
        .disabled(!viewState.isIdle)
        Button("Query Samples") {
            runAsync {
                let fetchStartTS = CACurrentMediaTime()
                let samples = try await healthStore.query(.init(.appleExerciseTime))
                let fetchEndTS = CACurrentMediaTime()
                print("did fetch samples (#=\(samples.count)) (took \(fetchEndTS - fetchStartTS) sec)")
                let mapResourcesStartTS = CACurrentMediaTime()
                _ = try samples.mapIntoResourceProxies()
                let mapResourcesEndTS = CACurrentMediaTime()
                print("did turn into resources (took \(mapResourcesEndTS - mapResourcesStartTS) sec)")
                await MainActor.run {
                    generateResourcesDuration = mapResourcesEndTS - mapResourcesStartTS
                }
            }
        }
        .disabled(!viewState.isIdle)
    }
    
    private func runAsync(_ operation: @Sendable @escaping () async throws -> Void) {
        precondition(viewState.isIdle)
        Task {
            viewState = .processing
            do {
                try await operation()
                viewState = .idle
            } catch {
                viewState = .failed(error)
            }
        }
    }
}


extension HKHealthStore {
    func query(_ sampleType: HKQuantityType) async throws -> [HKQuantitySample] {
        let cal = Calendar.current
        let predicate = HKSamplePredicate.quantitySample(
            type: sampleType
//            predicate: HKQuery.predicateForSamples(
//                withStart: cal.startOfDay(for: .now),
//                end: cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: .now))!
//            )
        )
        let descriptor = HKSampleQueryDescriptor(
            predicates: [predicate],
            sortDescriptors: [SortDescriptor(\.startDate, order: .forward)]
        )
        return try await descriptor.result(for: self)
    }
}
