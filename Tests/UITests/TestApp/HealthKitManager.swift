//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import Foundation
import HealthKit


class HealthKitManager: ObservableObject {
    var healthStore: HKHealthStore?
    
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
    
    
    func requestAuthorization() async throws {
        guard let healthStore,
              let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HKError(.errorHealthDataUnavailable)
        }
        
        try await healthStore.requestAuthorization(toShare: [stepType], read: [stepType])
    }
    
    func readStepCount() async throws -> [HKQuantitySample] {
        guard let healthStore else {
            return []
        }
        
        let query = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: HKQuantityType(.stepCount))],
            sortDescriptors: [],
            limit: HKObjectQueryNoLimit
        )
        
        return try await query.result(for: healthStore)
    }
    
    func writeSteps(startDate: Date, endDate: Date, steps: Double) async throws {
        guard let healthStore,
              let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HKError(.errorHealthDataUnavailable)
        }
        
        let stepsSample = HKQuantitySample(
            type: stepType,
            quantity: HKQuantity(unit: HKUnit.count(), doubleValue: steps),
            start: startDate,
            end: endDate
        )
        
        try await healthStore.save(stepsSample)
    }
}
