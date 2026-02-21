//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2026 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


enum TestView: String, CaseIterable, Identifiable {
    case writeData = "Write Data"
    case readData = "Read Data"
    case ecg = "Electrocardiogram"
    case healthRecords = "Health Records"
    case createWorkout = "Create Workout"
    case exportData = "Export Data"
    case mappingCompleteness = "Mapping Completeness"
    
    var id: some Hashable {
        rawValue
    }
    
    @MainActor @ViewBuilder var view: some View {
        switch self {
        case .writeData:
            WriteDataView()
        case .readData:
            ReadDataView(.stepCount)
        case .ecg:
            ElectrocardiogramTestView()
        case .healthRecords:
            HealthRecordsTestView()
        case .createWorkout:
            CreateWorkoutView()
        case .exportData:
            ExportDataView()
        case .mappingCompleteness:
            CheckMappingCompletenessView()
        }
    }
}
