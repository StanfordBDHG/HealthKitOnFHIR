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
        
        
        try await healthKit.askForAuthorization(for: .init(read: HKQuantityType.allKnownQuantities))
        try await healthKit.askForAuthorization(for: .init(read: HKCategoryType.allKnownCategories))
        try await healthKit.askForAuthorization(for: .init(read: HKCorrelationType.allKnownCorrelations))
        
        var sampleTypesWithoutData = Set<String>()
        var sampleTypesWithDevice = Set<String>()
        var sampleTypesWithoutDevice = Set<String>()
        
        try await hmmm(
            allSampleTypes: HKQuantityType.allKnownQuantities.compactMap { SampleType<HKQuantitySample>(HKQuantityTypeIdentifier(rawValue: $0.identifier)) },
            sampleTypesWithoutData: &sampleTypesWithoutData,
            sampleTypesWithDevice: &sampleTypesWithDevice,
            sampleTypesWithoutDevice: &sampleTypesWithoutDevice
        )
        try await hmmm(
            allSampleTypes: HKCategoryType.allKnownCategories.compactMap { SampleType<HKCategorySample>(HKCategoryTypeIdentifier(rawValue: $0.identifier)) },
            sampleTypesWithoutData: &sampleTypesWithoutData,
            sampleTypesWithDevice: &sampleTypesWithDevice,
            sampleTypesWithoutDevice: &sampleTypesWithoutDevice
        )
        try await hmmm(
            allSampleTypes: HKCorrelationType.allKnownCorrelations.compactMap { SampleType<HKCorrelation>(HKCorrelationTypeIdentifier(rawValue: $0.identifier)) },
            sampleTypesWithoutData: &sampleTypesWithoutData,
            sampleTypesWithDevice: &sampleTypesWithDevice,
            sampleTypesWithoutDevice: &sampleTypesWithoutDevice
        )
        
        print("Sample Types With Device:")
        for sampleType in sampleTypesWithDevice.sorted() {
            print("- \(sampleType)")
        }
        
        print()
        print("Sample Types Without Device:")
        for sampleType in sampleTypesWithoutDevice.sorted() {
            print("- \(sampleType)")
        }
        
        print()
        print("Sample Types Without Data:")
        for sampleType in sampleTypesWithoutData.sorted() {
            print("- \(sampleType)")
        }
    }
    
    
    private func hmmm<S: _HKSampleWithSampleType>(
        allSampleTypes: [SampleType<S>],
        sampleTypesWithoutData: inout Set<String>,
        sampleTypesWithDevice: inout Set<String>,
        sampleTypesWithoutDevice: inout Set<String>
    ) async throws {
        for sampleType in allSampleTypes {
            guard let sample = try await healthKit.query(sampleType, timeRange: .ever, limit: 1, sortedBy: [.init(\.startDate, order: .reverse)]).first else {
                sampleTypesWithoutData.insert(sampleType.id)
                continue
            }
            if sample.device != nil {
                sampleTypesWithDevice.insert(sampleType.id)
            } else {
                sampleTypesWithoutDevice.insert(sampleType.id)
            }
        }
    }
}


//extension SampleType where Sample._SampleType: _HKSampleTypeWithIdentifierType {
//    init?(_ sampleType: Sample._SampleType) {
//        self.init(Sample._SampleType._Identifier(rawValue: sampleType.identifier))
//    }
//}
