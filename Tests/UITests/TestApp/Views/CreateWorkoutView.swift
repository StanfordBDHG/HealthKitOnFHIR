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
    @State private var manager = HealthKitManager()

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

    /// Uses `HKWorkoutBuilder` to build an `HKWorkout`
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
        let workoutBuilder = HKWorkoutBuilder(
            healthStore: healthStore,
            configuration: configuration,
            device: nil
        )
        try await workoutBuilder.beginCollection(at: startDate)
        try await workoutBuilder.endCollection(at: endDate)
        if let workout = try await workoutBuilder.finishWorkout() {
            return workout
        } else {
            throw HKError(.errorHealthDataUnavailable)
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

            let observation = try workout.resource().get()

            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
            let data = try encoder.encode(observation)
            self.json = String(decoding: data, as: UTF8.self)
        } catch {
            print(error)
        }
    }
}
