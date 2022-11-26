//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI

struct ReadDataView: View {
    private func readSteps() async {
        guard await manager.requestAuthorization() == true else {
            return
        }
        let samples = await manager.readStepCount()

        guard let samples else {
            return
        }
        for sample in samples {
            // Convert to FHIR observation
            let fhirObservation = try? sample.observation

            // Print out JSON
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try? encoder.encode(fhirObservation)
            if let data, let json = String(data: data, encoding: .utf8) {
                print(json)
            }
        }
    }

    private var manager = HealthKitManager()

    var body: some View {
        Form {
            Section {
                Button("Read Data", action: {
                    Task {
                        await readSteps()
                    }
                })
            }
        }
    }
}

struct ReadDataView_Previews: PreviewProvider {
    static var previews: some View {
        ReadDataView()
    }
}
