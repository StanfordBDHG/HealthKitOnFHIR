//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import SpeziHealthKit
import SwiftUI


struct ReadDataView<Sample: _HKSampleWithSampleType>: View {
    @Environment(HealthKit.self) private var healthKit
    
    private let sampleType: SampleType<Sample>
    
    @State private var json = ""
    @State private var showingSheet = false
    
    
    var body: some View {
        Form {
            Section {
                Button("Read \(sampleType.displayTitle)") {
                    Task {
                        try await readData()
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
    
    
    init(_ sampleType: SampleType<Sample>) {
        self.sampleType = sampleType
    }
    
    private func readData() async throws {
        try await healthKit.askForAuthorization(for: .init(read: [sampleType]))
        let samples = try await healthKit.query(
            sampleType,
            timeRange: .ever,
            limit: 1,
            sortedBy: [.init(\.startDate, order: .reverse)]
        )
        let observations = samples.compactMap { try? $0.resource().get() }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        let data = try encoder.encode(observations)
        self.json = String(decoding: data, as: UTF8.self)
    }
}
