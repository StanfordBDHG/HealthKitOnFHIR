//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import HealthKit
import SwiftUI


struct HealthRecordsTestView: View {
    @StateObject private var manager = HealthKitManager()

    @State private var json = ""
    @State private var showingSheet = false


    var body: some View {
        Form {
            Section {
                Button("Read Allergies") {
                    Task {
                        try await readAllergies()
                        showingSheet.toggle()
                    }
                }
                    .sheet(isPresented: $showingSheet) {
                        JSONView(json: $json)
                    }
            }
        }
            .navigationBarTitle("Read Data")
    }


    private func readAllergies() async throws {
        try await manager.requestHealthRecordsAuthorization()

        let resources = try await manager.readHealthRecords(type: .allergyRecord)
            .compactMap { sample in
                try sample.allergyIntolerance
            }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]

        guard let data = try? encoder.encode(resources) else {
            return
        }

        self.json = String(decoding: data, as: UTF8.self)
    }
}

struct HealthRecordsTestView_Previews: PreviewProvider {
    static var previews: some View {
        HealthRecordsTestView()
    }
}
