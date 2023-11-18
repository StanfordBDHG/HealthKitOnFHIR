//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import SwiftUI

struct CreateWorkoutView: View {
    @StateObject private var manager = HealthKitManager()

    @State private var json = ""
    @State private var showingSheet = false

    var body: some View {
        Form {
            Section {
                Button("Create Sample Workout") {
                    Task {
                        await createWorkout()
                        showingSheet.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            JSONView(json: $json)
        }
            .navigationBarTitle("Create Workout")
    }

    /// Uses the `HKWorkoutBuilder` to build and save an `HKWorkout` to the health store
    private func buildWorkout(
        startDate: Date,
        endDate: Date,
        activityType: HKWorkoutActivityType
    ) async throws -> HKWorkout {
        guard let healthStore = self.manager.healthStore else {
            throw HKError(.errorHealthDataUnavailable)
        }

        let configuration = HKWorkoutConfiguration()
        configuration.activityType = activityType
        configuration.locationType = .indoor

        let workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: configuration, device: nil)

        return try await withCheckedThrowingContinuation { continuation in
            workoutBuilder.beginCollection(withStart: startDate) { success, error in
                guard success else {
                    continuation.resume(throwing: error ?? HKError(.errorHealthDataUnavailable))
                    return
                }

                workoutBuilder.endCollection(withEnd: endDate) { success, error in
                    guard success else {
                        continuation.resume(throwing: error ?? HKError(.errorHealthDataUnavailable))
                        return
                    }

                    workoutBuilder.finishWorkout { workout, error in
                        if let workout = workout {
                            continuation.resume(returning: workout)
                        } else {
                            continuation.resume(throwing: error ?? HKError(.errorHealthDataUnavailable))
                        }
                    }
                }
            }
        }
    }

    private func createWorkout() async {
        do {
            try await manager.requestWorkoutAuthorization()

            /// Use `HKWorkoutBuilder` to create the workout
            let workout = try await buildWorkout(
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600),
                activityType: .running
            )

            let observation = try workout.resource.get()

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
            let data = try encoder.encode(observation)
            self.json = String(decoding: data, as: UTF8.self)
        } catch {
            print(error)
        }
    }
}
