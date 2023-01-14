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
import ModelsR4
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
        
        let expectedCoding = Coding(
            code: "procedure".asFHIRStringPrimitive(),
            display: "Procedure".asFHIRStringPrimitive(),
            system: "http://terminology.hl7.org/CodeSystem/observation-category".asFHIRURIPrimitive()
        )
        guard observation?.category?.count == 1,
              observation?.category?.first?.coding == [expectedCoding] else {
            return
        }
        
        let expectedCodes = [
            Coding(
                code: "HKElectrocardiogram".asFHIRStringPrimitive(),
                display: "Electrocardiogram".asFHIRStringPrimitive(),
                system: "http://developer.apple.com/documentation/healthkit".asFHIRURIPrimitive()
            ),
            Coding(
                code: "131329".asFHIRStringPrimitive(),
                display: "MDC_ECG_ELEC_POTL_I".asFHIRStringPrimitive(),
                system: "urn:oid:2.16.840.1.113883.6.24".asFHIRURIPrimitive()
            )
        ]
        guard observation?.code.coding == expectedCodes else {
            return
        }
        
        guard observation?.component?.count == 12 else {
            return
        }

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
