//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKit
import SwiftUI


struct WriteDataView: View {
    private var manager = HealthKitManager()
    @State private var steps: Double?
    @State private var status = ""
    
    
    var body: some View {
        Form {
            Section {
                TextField("Number of steps...", value: $steps, format: .number)
                Button("Write Step Count") {
                    Task {
                        try await writeSteps()
                    }
                }
                    .disabled(steps == nil)
            }
            Section {
                if !self.status.isEmpty {
                    Text(status)
                }
            }
        }
        .navigationBarTitle("Write Data")
    }
    
    
    private func writeSteps() async throws {
        guard let steps else {
            return
        }
        
        try await manager.requestAuthorization()
        
        try await manager.writeSteps(
            startDate: Date() - 60 * 60,
            endDate: Date(),
            steps: steps
        )
        
        self.status = "Data successfully written!"
    }
}


struct WriteDataView_Previews: PreviewProvider {
    static var previews: some View {
        WriteDataView()
    }
}
