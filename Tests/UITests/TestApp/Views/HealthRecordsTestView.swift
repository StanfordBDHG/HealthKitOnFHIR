//
// This source file is part of the HealthKitOnFHIR open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import HealthKit
import ModelsR4
import SwiftUI


struct HealthRecordsTestView: View {
    @StateObject private var manager = HealthKitManager()
    
    @State private var json = ""
    @State private var showingSheet = false
    
    let recordTypes = [
        "HKClinicalTypeIdentifierAllergyRecord": "Allergies",
        "HKClinicalTypeIdentifierConditionRecord": "Conditions",
        "HKClinicalTypeIdentifierCoverageRecord": "Coverage",
        "HKClinicalTypeIdentifierImmunizationRecord": "Immunizations",
        "HKClinicalTypeIdentifierLabResultRecord": "Lab Results",
        "HKClinicalTypeIdentifierMedicationRecord": "Medications",
        "HKClinicalTypeIdentifierProcedureRecord": "Procedures",
        "HKClinicalTypeIdentifierVitalSignRecord": "Vital Signs"
    ]
    
    
    var body: some View {
        Form {
            Section {
                ForEach(recordTypes.sorted(by: <), id: \.key) { key, value in
                    Button("Read \(value)") {
                        _Concurrency.Task { // Models.R4 also has a `Task`
                            do {
                                let type = HKClinicalTypeIdentifier(rawValue: key)
                                try await readHealthRecords(type: type)
                            } catch {
                                print(error)
                            }
                            showingSheet.toggle()
                        }
                    }
                    .sheet(isPresented: $showingSheet) {
                        JSONView(json: $json)
                    }
                }
            }
        }
        .navigationBarTitle("Read Data")
    }
    
    
    private func readHealthRecords(type: HKClinicalTypeIdentifier) async throws {
        try await manager.requestHealthRecordsAuthorization()
        
        let resources: [Resource] = try await manager.readHealthRecords(type: type)
            .compactMap { sample in
                do {
                    return try sample.resource.get()
                } catch {
                    print(error.localizedDescription)
                }
                return nil
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
