//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import ModelsR4


extension HKCategorySample: FHIRObservationBuildable {
    func build(_ observation: Observation, mapping: HKSampleMapping) throws {
        guard let mapping = mapping.categorySampleMapping[self.categoryType] else {
            throw HealthKitOnFHIRError.notSupported
        }
        let assocDataInfo = try categoryType.associatedDataInfo
        for code in mapping.codings {
            observation.appendCoding(code.coding)
        }
        if let valueType = assocDataInfo.valueType {
            guard let value = valueType.init(rawValue: self.value) else {
                throw HealthKitOnFHIRError.invalidValue
            }
            observation.setValue(try value.fhirCategoryValue)
        } else {
            // If the sample doesn't have a value type associated with it, we set the value to the category identifier
            observation.setValue(self.categoryType.identifier)
        }
        for metadataKey in assocDataInfo.metadataKeys {
            guard let value = self.metadata?[metadataKey] else {
                continue
            }
            if let quantity = value as? HKQuantity {
                observation.appendComponent(try quantity.buildObservationComponent(for: HKQuantityType(.vo2Max)))
            } else if let value = value as? Bool {
                guard let coding = HKCategoryType.coding(forMetadataKey: metadataKey) else {
                    continue
                }
                observation.appendComponent(ObservationComponent(
                    code: CodeableConcept(coding: [coding]),
                    value: .boolean(value.asPrimitive())
                ))
            } else {
                continue
            }
        }
    }
}

extension HKCategoryType {
    fileprivate static func coding(forMetadataKey key: String) -> Coding? {
        switch key {
        case HKMetadataKeyMenstrualCycleStart:
            Coding(
                code: key.asFHIRStringPrimitive(),
                display: "Menstrual Cycle Start".asFHIRStringPrimitive(),
                system: "http://developer.apple.com/documentation/healthkit".asFHIRURIPrimitive()
            )
        case HKMetadataKeySexualActivityProtectionUsed:
            Coding(
                code: key.asFHIRStringPrimitive(),
                display: "Sexual Activity: Protection Used".asFHIRStringPrimitive(),
                system: "http://developer.apple.com/documentation/healthkit".asFHIRURIPrimitive()
            )
        default:
            nil
        }
    }
}


extension HKCategoryType {
    /// Information about the associated data carried by a sample of a specific category type.
    struct AssociatedDataInfo {
        static var noDataCarried: Self { .init(valueType: nil) }
        
        let valueType: (any FHIRCompatibleHKCategoryValueType.Type)?
        let metadataKeys: Set<String>
        
        init(valueType: (any FHIRCompatibleHKCategoryValueType.Type)?, metadataKeys: Set<String> = []) {
            self.valueType = valueType
            self.metadataKeys = metadataKeys
        }
    }
    
    /// The category type's associated (FHIR-compatible) Category Value Type.
    ///
    /// - throws: if the category type is unknown to HealthKitOnFHIR.
    var associatedDataInfo: AssociatedDataInfo {
        get throws {
            try HKCategoryTypeIdentifier(rawValue: self.identifier).associatedDataInfo
        }
    }
}


extension HKCategoryTypeIdentifier {
    /// The category type's associated (FHIR-compatible) Category Value Type.
    ///
    /// - throws: if the category type is unknown to HealthKitOnFHIR.
    var associatedDataInfo: HKCategoryType.AssociatedDataInfo {
        get throws {
            switch self {
            case .appleStandHour:
                return .init(valueType: HKCategoryValueAppleStandHour.self)
            case .environmentalAudioExposureEvent:
                return .init(valueType: HKCategoryValueEnvironmentalAudioExposureEvent.self)
            case .headphoneAudioExposureEvent:
                return .init(valueType: HKCategoryValueHeadphoneAudioExposureEvent.self)
            case .highHeartRateEvent, .lowHeartRateEvent:
                return .init(
                    valueType: nil,
                    metadataKeys: [HKMetadataKeyHeartRateEventThreshold]
                )
            case .irregularHeartRhythmEvent:
                return .noDataCarried
            case .lowCardioFitnessEvent:
                return .init(
                    valueType: HKCategoryValueLowCardioFitnessEvent.self,
                    metadataKeys: [HKMetadataKeyVO2MaxValue, HKMetadataKeyLowCardioFitnessEventThreshold]
                )
            case .mindfulSession:
                return .noDataCarried
            case .appleWalkingSteadinessEvent:
                return .init(valueType: HKCategoryValueAppleWalkingSteadinessEvent.self)
            case .handwashingEvent, .toothbrushingEvent:
                return .noDataCarried
            case .cervicalMucusQuality:
                return .init(valueType: HKCategoryValueCervicalMucusQuality.self)
            case .contraceptive:
                return .init(valueType: HKCategoryValueContraceptive.self)
            case .infrequentMenstrualCycles, .intermenstrualBleeding, .irregularMenstrualCycles, .lactation, .persistentIntermenstrualBleeding:
                return .noDataCarried
            case .menstrualFlow:
                return .init(
                    valueType: HKCategoryValueMenstrualFlow.self,
                    metadataKeys: [HKMetadataKeyMenstrualCycleStart]
                )
            case .ovulationTestResult:
                return .init(valueType: HKCategoryValueOvulationTestResult.self)
            case .pregnancy:
                return .noDataCarried
            case .pregnancyTestResult:
                return .init(valueType: HKCategoryValuePregnancyTestResult.self)
            case .progesteroneTestResult:
                return .init(valueType: HKCategoryValueProgesteroneTestResult.self)
            case .prolongedMenstrualPeriods:
                return .noDataCarried
            case .sexualActivity:
                return .init(valueType: nil, metadataKeys: [HKMetadataKeySexualActivityProtectionUsed])
            case .sleepAnalysis:
                return .init(valueType: HKCategoryValueSleepAnalysis.self)
            case .abdominalCramps:
                return .init(valueType: HKCategoryValueSeverity.self)
            case .acne:
                return .init(valueType: HKCategoryValueSeverity.self)
            case .appetiteChanges:
                return .init(valueType: HKCategoryValueAppetiteChanges.self)
            case .bladderIncontinence, .bloating, .breastPain, .chestTightnessOrPain, .chills, .constipation,
                    .coughing, .diarrhea, .dizziness, .drySkin, .fainting, .fatigue, .fever, .generalizedBodyAche, .hairLoss,
                    .headache, .heartburn, .hotFlashes, .lossOfSmell, .lossOfTaste, .lowerBackPain, .memoryLapse, .nausea,
                    .nightSweats, .pelvicPain, .rapidPoundingOrFlutteringHeartbeat, .runnyNose, .shortnessOfBreath, .sinusCongestion,
                    .skippedHeartbeat, .soreThroat, .vaginalDryness, .vomiting, .wheezing:
                return .init(valueType: HKCategoryValueSeverity.self)
            case .moodChanges, .sleepChanges:
                return .init(valueType: HKCategoryValuePresence.self)
            default:
                if #available(iOS 18.0, *), self == .bleedingDuringPregnancy || self == .bleedingAfterPregnancy {
                    return .init(valueType: HKCategoryValueVaginalBleeding.self)
                } else {
                    throw HealthKitOnFHIRError.notSupported
                }
            }
        }
    }
}
