//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink("Write Data", destination: WriteDataView())
                    NavigationLink("Read Data", destination: ReadDataView())
                    NavigationLink("Electrocardiogram", destination: ElectrocardiogramTestView())
                    NavigationLink("Health Records", destination: HealthRecordsTestView())
                    NavigationLink("Create Workout", destination: CreateWorkoutView())
                    NavigationLink("Export Data", destination: ExportDataView())
                    NavigationLink("Mapping Completeness", destination: CheckMappingCompletenessView())
                }
            }
            .navigationBarTitle("HealthKitOnFHIR Tests")
        }
    }
}
