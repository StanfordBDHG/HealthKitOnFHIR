//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct ReadDataView: View {
    private var manager = HealthKitManager()
    @State private var data = ""
    @State private var showingSheet = false

    var body: some View {
        Form {
            Section {
                Button("Read Step Count", action: {
                    Task {
                        await readSteps()
                        showingSheet.toggle()
                    }
                }).sheet(isPresented: $showingSheet) {
                    JSONView(data: self.$data)
                }
            }
        }
        .navigationBarTitle("Read Data")
    }

    private func readSteps() async {
        guard await manager.requestAuthorization() == true else {
            return
        }

        let samples = await manager.readStepCount()

        for sample in samples {
            // Convert to FHIR observation
            let fhirObservation = try? sample.observation

            // Print out JSON
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try? encoder.encode(fhirObservation)
            if let data, let json = String(data: data, encoding: .utf8) {
                self.data = json
                print(json)
            }
        }
    }
}

struct ReadDataView_Previews: PreviewProvider {
    static var previews: some View {
        ReadDataView()
    }
}
