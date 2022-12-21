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
    
    
    func requestStepAuthorization() async throws {
        guard let healthStore,
              let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HKError(.errorHealthDataUnavailable)
        }
        
        try await healthStore.requestAuthorization(toShare: [stepType], read: [stepType])
    }
    
    func readStepCount() async throws -> [HKQuantitySample] {
        guard let healthStore else {
            throw HKError(.errorHealthDataUnavailable)
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
    
    // MARK: - Electrocardiogram
    
    func requestElectrocardiogramAuthorization() async throws {
        guard let healthStore else {
            throw HKError(.errorHealthDataUnavailable)
        }
        
        var readTypes: [HKObjectType] = HKElectrocardiogram.correlatedSymptomTypes
        readTypes.append(HKQuantityType.electrocardiogramType())
        try await healthStore.requestAuthorization(toShare: [], read: Set(readTypes))
    }
    
    func readElectrocardiogram() async throws -> HKElectrocardiogram? {
        guard let healthStore else {
            throw HKError(.errorHealthDataUnavailable)
        }
        
        let query = HKSampleQueryDescriptor(
            predicates: [.electrocardiogram()],
            sortDescriptors: [],
            limit: 1
        )
        
        return try await query.result(for: healthStore).first
    }
    
    func readSymptoms(for electrocardiogram: HKElectrocardiogram) async throws -> HKElectrocardiogram.Symptoms {
        guard let healthStore else {
            throw HKError(.errorHealthDataUnavailable)
        }
        return try await electrocardiogram.symptoms(from: healthStore)
    }
    
    func readVoltageMeasurements(for electrocardiogram: HKElectrocardiogram) async throws -> HKElectrocardiogram.VoltageMeasurements {
        guard let healthStore else {
            throw HKError(.errorHealthDataUnavailable)
        }
        return try await electrocardiogram.voltageMeasurements(from: healthStore)
    }
}
