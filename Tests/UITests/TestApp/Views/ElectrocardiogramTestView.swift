//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
@preconcurrency import HealthKit
import HealthKitOnFHIR
import SwiftUI


struct ElectrocardiogramTestView: View {
    @StateObject private var manager = HealthKitManager()
    
    @State private var observation: Observation?
    @State private var passed = false
    @State private var json = ""
    @State private var showingSheet = false
    
    
    var body: some View {
        Form {
            Section {
                Button("Read Electrocardiogram") {
                    _Concurrency.Task {
                        try await readElectrocardiogramTest()
                    }
                }
                if passed {
                    Text("Passed")
                }
                if observation != nil {
                    Button("See JSON") {
                        _Concurrency.Task {
                            try readCreateJSON()
                            showingSheet.toggle()
                        }
                    }
                        .sheet(isPresented: $showingSheet) {
                            JSONView(json: $json)
                        }
                }
            }
        }
            .navigationBarTitle("Read Electrocardiogram")
    }
    
    
    private func readElectrocardiogramTest() async throws {
        try await manager.requestElectrocardiogramAuthorization()
        
        guard let electrocardiogram = try await manager.readElectrocardiogram() else {
            return
        }
        let symptoms = try await manager.readSymptoms(for: electrocardiogram)
        let voltageMeasurements = try await manager.readVoltageMeasurements(for: electrocardiogram)

        self.observation = try electrocardiogram.observation(
            symptoms: symptoms,
            voltageMeasurements: voltageMeasurements
        )
        
        self.passed = true
    }
    
    private func readCreateJSON() throws {
        guard let observation else {
            return
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        
        guard let data = try? encoder.encode(observation) else {
            return
        }
        
        self.json = String(decoding: data, as: UTF8.self)
    }
}


struct ElectrocardiogramTestView_Previews: PreviewProvider {
    static var previews: some View {
        ElectrocardiogramTestView()
    }
}
