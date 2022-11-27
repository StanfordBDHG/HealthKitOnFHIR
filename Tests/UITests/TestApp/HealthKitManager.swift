//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//


import Foundation
import HealthKit

class HealthKitManager {
    var healthStore: HKHealthStore?

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }

    func requestAuthorization() async -> Bool {
        guard let healthStore,
              let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
              let _: () = try? await healthStore.requestAuthorization(toShare: [stepType], read: [stepType]) else {
            return false
        }
        return true
    }

    func readStepCount() async -> [HKQuantitySample] {
        guard let healthStore,
              let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else {
            return []
        }

        let samples = try? await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HKQuantitySample], Error>) in
                healthStore.execute(HKSampleQuery(
                    sampleType: sampleType,
                    predicate: nil,
                    limit: Int(HKObjectQueryNoLimit),
                    sortDescriptors: nil
                ) { _, samples, error in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let samples = samples as? [HKQuantitySample] else {
                        return
                    }

                    continuation.resume(returning: samples)
                })
        }

        return samples ?? []
    }


    func writeSteps(startDate: Date, endDate: Date, steps: Double) async -> Bool {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount),
        let healthStore else {
            return false
        }

        let stepsSample = HKQuantitySample(
            type: stepType,
            quantity: HKQuantity(unit: HKUnit.count(), doubleValue: steps),
            start: startDate,
            end: endDate
        )

        do {
            try await healthStore.save(stepsSample)
            return true
        } catch {
            print(error.localizedDescription)
        }

        return false
    }
}
