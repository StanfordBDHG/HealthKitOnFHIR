//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit


extension HKElectrocardiogram.Classification: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .notSet:
                return "notSet"
            case .sinusRhythm:
                return "sinusRhythm"
            case .atrialFibrillation:
                return "atrialFibrillation"
            case .inconclusiveLowHeartRate:
                return "inconclusiveLowHeartRate"
            case .inconclusiveHighHeartRate:
                return "inconclusiveHighHeartRate"
            case .inconclusivePoorReading:
                return "inconclusivePoorReading"
            case .inconclusiveOther:
                return "inconclusiveOther"
            case .unrecognized:
                return "unrecognized"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}


extension HKElectrocardiogram.SymptomsStatus: HKCategoryValueDescription {
    var categoryValueDescription: String {
        get throws {
            switch self {
            case .notSet:
                return "notSet"
            case .none:
                return "none"
            case .present:
                return "present"
            @unknown default:
                throw HealthKitOnFHIRError.invalidValue
            }
        }
    }
}


extension HKElectrocardiogram {
    /// The `Symptoms` contain related `HKCategoryType` instances coded as `HKCategoryValueSeverity` enums related to an `HKElectrocardiogram`.
    public typealias Symptoms = [HKCategoryType: HKCategoryValueSeverity]
    /// The raw voltage measurements are defined as `HKQuantity` samples that are correlating to a specific measurement time.
    ///
    /// The voltage measurements must be sorted by time interval.
    public typealias VoltageMeasurements = [(time: TimeInterval, value: HKQuantity)]
    
    
    /// Creates a FHIR observation incorporating additional `Symptoms` and`VoltageMeasurements` collected in HealthKit.
    /// If you do not need `HKElectrocardiogram` specific context added you can use the generic `observation` extension on `HKSample`.
    ///
    /// - Parameters:
    ///   - symptoms: The `Symptoms` that should be encoded in the FHIR observation.
    ///   - voltageMeasurements: The URL pointing to the raw voltage measurement data corrolated ot the FHIR observation.
    ///   - mapping: The `HKSampleMapping` used to populate the FHIR observation.
    public func observation(
        symptoms: Symptoms,
        voltageMeasurements: VoltageMeasurements,
        withMapping mapping: HKSampleMapping = HKSampleMapping.default
    ) throws -> Observation {
        var observation = try observation(withMapping: mapping)
        
        if !symptoms.isEmpty {
            try appendSymptomsComponent(&observation, symptoms: symptoms, mappings: mapping)
        }
        
        if !voltageMeasurements.isEmpty {
            try appendVoltageMeasurementsComponent(&observation, voltageMeasurements: voltageMeasurements, mappings: mapping)
        }
        
        return observation
    }
    
    
    func buildObservation(
        _ observation: inout Observation,
        mappings: HKSampleMapping = HKSampleMapping.default
    ) throws {
        let mapping = mappings.electrocardiogramMapping
        
        for code in mapping.codings {
            observation.appendCoding(code.coding)
        }
        
        for category in mapping.categories {
            observation.appendCategory(
                CodeableConcept(coding: [category.coding])
            )
        }
        
        try appendNumberOfVoltageMeasurementsComponent(&observation, mapping: mapping)
        try appendSamplingFrequencyComponent(&observation, mapping: mapping)
        try appendClassificationComponent(&observation, mapping: mapping)
        try appendAverageHeartRateComponent(&observation, mapping: mapping)
        try appendSymptomsStatusComponent(&observation, mapping: mapping)
    }
    
    
    private func appendNumberOfVoltageMeasurementsComponent(
        _ observation: inout Observation,
        mapping: HKElectrocardiogramMapping
    ) throws {
        // Number Of Voltage Measurements
        let numberOfVoltageMeasurementsComponent = ObservationComponent(
            code: CodeableConcept(coding: mapping.numberOfVoltageMeasurements.codings.map(\.coding))
        )
        numberOfVoltageMeasurementsComponent.value = .quantity(
            Quantity(
                code: mapping.numberOfVoltageMeasurements.unit.code?.asFHIRStringPrimitive(),
                system: mapping.numberOfVoltageMeasurements.unit.system?.asFHIRURIPrimitive(),
                unit: mapping.numberOfVoltageMeasurements.unit.unit.asFHIRStringPrimitive(),
                value: Double(numberOfVoltageMeasurements).asFHIRDecimalPrimitive()
            )
        )
        observation.appendComponent(numberOfVoltageMeasurementsComponent)
    }
    
    private func appendSamplingFrequencyComponent(
        _ observation: inout Observation,
        mapping: HKElectrocardiogramMapping
    ) throws {
        if let samplingFrequency {
            let samplingFrequencyComponent = ObservationComponent(
                code: CodeableConcept(coding: mapping.samplingFrequency.codings.map(\.coding))
            )
            samplingFrequencyComponent.value = .quantity(
                Quantity(
                    code: mapping.samplingFrequency.unit.code?.asFHIRStringPrimitive(),
                    system: mapping.samplingFrequency.unit.system?.asFHIRURIPrimitive(),
                    unit: mapping.samplingFrequency.unit.unit.asFHIRStringPrimitive(),
                    value: samplingFrequency.doubleValue(for: mapping.samplingFrequency.unit.hkunit).asFHIRDecimalPrimitive()
                )
            )
            observation.appendComponent(samplingFrequencyComponent)
        }
    }
    
    private func appendClassificationComponent(
        _ observation: inout Observation,
        mapping: HKElectrocardiogramMapping
    ) throws {
        let classificationComponent = ObservationComponent(code: CodeableConcept(coding: mapping.classification.codings.map(\.coding)))
        classificationComponent.value = .string(try classification.categoryValueDescription.asFHIRStringPrimitive())
        observation.appendComponent(classificationComponent)
    }
    
    private func appendAverageHeartRateComponent(
        _ observation: inout Observation,
        mapping: HKElectrocardiogramMapping
    ) throws {
        if let averageHeartRate {
            let averageHeartRateComponent = ObservationComponent(
                code: CodeableConcept(coding: mapping.averageHeartRate.codings.map(\.coding))
            )
            averageHeartRateComponent.value = .quantity(
                Quantity(
                    code: mapping.averageHeartRate.unit.code?.asFHIRStringPrimitive(),
                    system: mapping.averageHeartRate.unit.system?.asFHIRURIPrimitive(),
                    unit: mapping.averageHeartRate.unit.unit.asFHIRStringPrimitive(),
                    value: averageHeartRate.doubleValue(for: mapping.averageHeartRate.unit.hkunit).asFHIRDecimalPrimitive()
                )
            )
            observation.appendComponent(averageHeartRateComponent)
        }
    }
    
    private func appendSymptomsStatusComponent(
        _ observation: inout Observation,
        mapping: HKElectrocardiogramMapping
    ) throws {
        let symptomsStatusComponent = ObservationComponent(code: CodeableConcept(coding: mapping.symptomsStatus.codings.map(\.coding)))
        symptomsStatusComponent.value = .string(try symptomsStatus.categoryValueDescription.asFHIRStringPrimitive())
        observation.appendComponent(symptomsStatusComponent)
    }
    
    
    private func appendSymptomsComponent(
        _ observation: inout Observation,
        symptoms: Symptoms,
        mappings: HKSampleMapping
    ) throws {
        for symptom in symptoms {
            guard let mapping = mappings.categorySampleMapping[symptom.key] else {
                throw HealthKitOnFHIRError.notSupported
            }
            
            let symptomComponent = ObservationComponent(
                code: CodeableConcept(coding: mapping.codings.map(\.coding))
            )
            symptomComponent.value = .string(try symptom.value.categoryValueDescription.asFHIRStringPrimitive())
            observation.appendComponent(symptomComponent)
        }
    }
    
    
    private func appendVoltageMeasurementsComponent(
        _ observation: inout Observation,
        voltageMeasurements: VoltageMeasurements,
        mappings: HKSampleMapping
    ) throws {
        let mapping = mappings.electrocardiogramMapping.voltageMeasurements
        let voltageMeasurements = voltageMeasurements.sorted(by: { $0.time < $1.time })
        
        // Number of milliseconds between samples
        let period: Double
        if let samplingFrequency {
            period = 1.0 / samplingFrequency.doubleValue(for: HKUnit.hertz())
        } else {
            period = (voltageMeasurements.last?.time ?? 0.0) / Double(voltageMeasurements.count)
        }
        
        // Batch the measurements in 10 Second Intervals
        let voltageMeasurementBatches = voltageMeasurements
            .split { time, _ in
                let remainder = time.remainder(dividingBy: 10.0)
                return remainder <= period / 2
            }
        
        for voltageMeasurementBatch in voltageMeasurementBatches {
            // Create a space separated string of all the measurement values as defined by the mapping unit
            let data = voltageMeasurementBatch
                .map {
                    $0.value.doubleValue(for: mapping.unit.hkunit).description
                }
                .joined(separator: " ")
            
            let voltageMeasurementBatchComponent = ObservationComponent(
                code: CodeableConcept(coding: mapping.codings.map(\.coding))
            )
            voltageMeasurementBatchComponent.value = .sampledData(
                SampledData(
                    data: data.asFHIRStringPrimitive(),
                    dimensions: 1,
                    origin: Quantity(
                        code: mapping.unit.code?.asFHIRStringPrimitive(),
                        system: mapping.unit.system?.asFHIRURIPrimitive(),
                        unit: mapping.unit.unit.asFHIRStringPrimitive(),
                        value: 0.asFHIRDecimalPrimitive()
                    ),
                    period: period.asFHIRDecimalPrimitive()
                )
            )
            observation.appendComponent(voltageMeasurementBatchComponent)
        }
    }
}
