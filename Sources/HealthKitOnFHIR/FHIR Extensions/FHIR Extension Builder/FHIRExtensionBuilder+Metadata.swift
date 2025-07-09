//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKit
import ModelsR4


extension FHIRExtensionUrls {
    // SAFETY: this is in fact safe, since the FHIRPrimitive's `extension` property is empty.
    // As a result, the actual instance doesn't contain any mutable state, and since this is a let,
    // it also never can be mutated to contain any.
    /// Url of a FHIR Extension containing, if applicable, encoded metadata of the `HKObject` from which a FHIR `Observation` was created.
    public nonisolated(unsafe) static let metadata = "https://bdh.stanford.edu/fhir/defs/metadata".asFHIRURIPrimitive()!
    // swiftlint:disable:previous force_unwrapping
}


extension FHIRExtensionBuilderProtocol where Self == FHIRExtensionBuilder<HKObject> {
    /// A FHIR Extension Builder that writes encoded metadata of a HealthKit sample into a FHIR `Observation` created from the sample.
    public static var metadata: FHIRExtensionBuilder<HKObject> {
        .init { (object: HKObject, observation) in // swiftlint:disable:this closure_body_length
            guard let metadata = object.metadata, !metadata.isEmpty else {
                observation.removeAllExtensions(withUrl: FHIRExtensionUrls.metadata)
                return
            }
            let metadataExtension = Extension(url: FHIRExtensionUrls.metadata)
            for (key, value) in metadata {
                // The HKObject docs state that "Keys must be NSString and values must be either NSString, NSNumber, NSDate, or HKQuantity".
                // Additionally, there are some HKMetadataKey constants which say that they store a BOOL, so we support that as well.
                let extensionValue: Extension.ValueX
                switch value {
                case let value as String:
                    extensionValue = .string(value.asFHIRStringPrimitive())
                case let value as NSNumber:
                    extensionValue = .decimal(FHIRPrimitive(FHIRDecimal(value.decimalValue)))
                case let value as Date:
                    extensionValue = .dateTime(FHIRPrimitive(try DateTime(date: value)))
                case let value as Bool:
                    extensionValue = .boolean(value.asPrimitive())
                case let value as HKQuantity:
                    switch key {
                    case HKMetadataKeyWeatherTemperature:
                        extensionValue = .quantity(value.buildQuantity(mapping: .weatherTemperature))
                    case HKMetadataKeyWeatherHumidity:
                        extensionValue = .quantity(value.buildQuantity(mapping: .weatherHumidity))
                    case HKMetadataKeySessionEstimate:
                        guard let sample = object as? HKQuantitySample,
                              let mapping = HKQuantitySampleMapping.default[sample.quantityType] else {
                            continue // should be unreachable. skipping
                        }
                        extensionValue = .quantity(value.buildQuantity(mapping: mapping))
                    case HKMetadataKeyHeartRateRecoveryActivityDuration:
                        extensionValue = .quantity(value.buildQuantity(mapping: .heartRateRecoveryActivityDuration))
                    case HKMetadataKeyHeartRateRecoveryMaxObservedRecoveryHeartRate:
                        extensionValue = .quantity(value.buildQuantity(mapping: .heartRateRecoveryMaxObservedRecoveryHeartRate))
                    case HKMetadataKeyAverageSpeed:
                        extensionValue = .quantity(value.buildQuantity(mapping: .averageSpeed))
                    case HKMetadataKeyMaximumSpeed:
                        extensionValue = .quantity(value.buildQuantity(mapping: .maximumSpeed))
                    case HKMetadataKeyAlpineSlopeGrade:
                        extensionValue = .quantity(value.buildQuantity(mapping: .alpineSlopeGrade))
                    case HKMetadataKeyElevationAscended:
                        extensionValue = .quantity(value.buildQuantity(mapping: .elevationAscended))
                    case HKMetadataKeyElevationDescended:
                        extensionValue = .quantity(value.buildQuantity(mapping: .elevationDescended))
                    case HKMetadataKeyFitnessMachineDuration:
                        extensionValue = .quantity(value.buildQuantity(mapping: .fitnessMachineDuration))
                    case HKMetadataKeyIndoorBikeDistance:
                        extensionValue = .quantity(value.buildQuantity(mapping: .indoorBikeDistance))
                    case HKMetadataKeyCrossTrainerDistance:
                        extensionValue = .quantity(value.buildQuantity(mapping: .crossTrainerDistance))
                    case HKMetadataKeyHeartRateEventThreshold:
                        extensionValue = .quantity(value.buildQuantity(mapping: .highHeartRateEventThreshold))
                    case HKMetadataKeyAverageMETs:
                        extensionValue = .quantity(value.buildQuantity(mapping: .averageMETs))
                    case HKMetadataKeyAudioExposureLevel:
                        extensionValue = .quantity(value.buildQuantity(mapping: .audioExposureLevel))
                    case HKMetadataKeyAudioExposureDuration:
                        extensionValue = .quantity(value.buildQuantity(mapping: .audioExposureDuration))
                    case HKMetadataKeyBarometricPressure:
                        extensionValue = .quantity(value.buildQuantity(mapping: .barometricPressure))
                    case HKMetadataKeyVO2MaxValue:
                        extensionValue = .quantity(value.buildQuantity(mapping: .vo2MaxValue))
                    case HKMetadataKeyLowCardioFitnessEventThreshold:
                        extensionValue = .quantity(value.buildQuantity(mapping: .lowCardioFitnessEventThreshold))
                    case HKMetadataKeyHeadphoneGain:
                        extensionValue = .quantity(value.buildQuantity(mapping: .headphoneGain))
                    case HKMetadataKeyMaximumLightIntensity:
                        extensionValue = .quantity(value.buildQuantity(mapping: .maximumLightIntensity))
                    default:
                        print("Encountered unexpected HKQuantity metadata value for key '\(key)': \(value). Skipping.")
                        continue
                    }
                default:
                    print("Encountered unexpected HKSample metadata value of type \(type(of: value)), for key '\(key)': \(value). Skipping.")
                    continue
                }
                metadataExtension.appendExtension(
                    Extension(url: FHIRExtensionUrls.metadata.appending(component: key), value: extensionValue),
                    replaceAllExistingWithSameUrl: true
                )
                observation.appendExtension(metadataExtension, replaceAllExistingWithSameUrl: true)
            }
        }
    }
}


extension HKQuantitySampleMapping {
    // swiftlint:disable:next force_unwrapping
    private static let healthKitCodingSystemUrl = URL(string: "http://developer.apple.com/documentation/healthkit")!
    // swiftlint:disable:next force_unwrapping
    private static let unitsOfMeasureCodingSystemUrl = URL(string: "http://unitsofmeasure.org")!
    
    fileprivate static let weatherTemperature = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyWeatherTemperature",
                display: "Weather Temperature",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .degreeCelsius(),
            unit: "C",
            system: unitsOfMeasureCodingSystemUrl,
            code: "Cel"
        )
    )
    
    fileprivate static let weatherHumidity = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyWeatherHumidity",
                display: "Weather Humidity",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .percent(),
            unit: "%",
            system: unitsOfMeasureCodingSystemUrl,
            code: "%"
        )
    )
    
    fileprivate static let heartRateRecoveryActivityDuration = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyHeartRateRecoveryActivityDuration",
                display: "Heart Rate Recovery Activity Duration",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .second(),
            unit: "s",
            system: unitsOfMeasureCodingSystemUrl,
            code: "s"
        )
    )
    
    fileprivate static let heartRateRecoveryMaxObservedRecoveryHeartRate = HKQuantitySampleMapping( // swiftlint:disable:this identifier_name
        codings: [
            MappedCode(
                code: "HKMetadataKeyHeartRateRecoveryMaxObservedRecoveryHeartRate",
                display: "Heart Rate Recovery Max Observed Recovery Heart Rate",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .count().unitDivided(by: .minute()),
            unit: "beats/minute",
            system: unitsOfMeasureCodingSystemUrl,
            code: "/min"
        )
    )
    
    fileprivate static let averageSpeed = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyAverageSpeed",
                display: "Average Speed",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .meter().unitDivided(by: .second()),
            unit: "m/sec",
            system: unitsOfMeasureCodingSystemUrl,
            code: "m/s"
        )
    )
    
    fileprivate static let maximumSpeed = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyMaximumSpeed",
                display: "Maximum Speed",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .meter().unitDivided(by: .second()),
            unit: "m/sec",
            system: unitsOfMeasureCodingSystemUrl,
            code: "m/s"
        )
    )
    
    fileprivate static let alpineSlopeGrade = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyAlpineSlopeGrade",
                display: "Alpine Slope Grade",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .percent(),
            unit: "%",
            system: unitsOfMeasureCodingSystemUrl,
            code: "%"
        )
    )
    
    fileprivate static let elevationAscended = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyElevationAscended",
                display: "Elevation Ascended",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .meter(),
            unit: "m",
            system: unitsOfMeasureCodingSystemUrl,
            code: "m"
        )
    )
    
    fileprivate static let elevationDescended = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyElevationDescended",
                display: "Elevation Descended",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .meter(),
            unit: "m",
            system: unitsOfMeasureCodingSystemUrl,
            code: "m"
        )
    )
    
    fileprivate static let fitnessMachineDuration = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyFitnessMachineDuration",
                display: "Fitness Machine Duration",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .second(),
            unit: "s",
            system: unitsOfMeasureCodingSystemUrl,
            code: "s"
        )
    )
    
    fileprivate static let indoorBikeDistance = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyIndoorBikeDistance",
                display: "Indoor Bike Distance",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .meter(),
            unit: "m",
            system: unitsOfMeasureCodingSystemUrl,
            code: "m"
        )
    )
    
    fileprivate static let crossTrainerDistance = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyCrossTrainerDistance",
                display: "Cross Trainer Distance",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .meter(),
            unit: "m",
            system: unitsOfMeasureCodingSystemUrl,
            code: "m"
        )
    )
    
    fileprivate static let highHeartRateEventThreshold = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyHeartRateEventThreshold",
                display: "Heart Rate Event Threshold",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .count().unitDivided(by: .minute()),
            unit: "beats/min",
            system: unitsOfMeasureCodingSystemUrl,
            code: "/min"
        )
    )
    
    fileprivate static let averageMETs = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyAverageMETs",
                display: "Average METs",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .largeCalorie().unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .hour())),
            unit: "kcal/(kg*hr)",
            system: unitsOfMeasureCodingSystemUrl,
            code: "kcal/(kg*hr)"
        )
    )
    
    fileprivate static let audioExposureLevel = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyAudioExposureLevel",
                display: "Audio Exposure Level",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .init(from: "dBASPL"),
            unit: "dB(SPL)",
            system: unitsOfMeasureCodingSystemUrl,
            code: "dB(SPL)"
        )
    )
    
    fileprivate static let audioExposureDuration = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyAudioExposureDuration",
                display: "Audio Exposure Duration",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .second(),
            unit: "s",
            system: unitsOfMeasureCodingSystemUrl,
            code: "s"
        )
    )
    
    fileprivate static let barometricPressure = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyBarometricPressure",
                display: "Barometric Pressure",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .millimeterOfMercury(),
            unit: "mmHg",
            system: unitsOfMeasureCodingSystemUrl,
            code: "mm[Hg]"
        )
    )
    
    fileprivate static let vo2MaxValue = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyVO2MaxValue",
                display: "VO2Max Value",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .init(from: "mL/kg*min"),
            unit: "mL/kg/min",
            system: unitsOfMeasureCodingSystemUrl,
            code: "mL/kg/min"
        )
    )
    
    fileprivate static let lowCardioFitnessEventThreshold = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyLowCardioFitnessEventThreshold",
                display: "Low Cardio Fitness Event Threshold",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .init(from: "mL/kg*min"),
            unit: "mL/kg/min",
            system: unitsOfMeasureCodingSystemUrl,
            code: "mL/kg/min"
        )
    )
    
    fileprivate static let headphoneGain = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyHeadphoneGain",
                display: "Headphone Gain",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .decibelAWeightedSoundPressureLevel(),
            unit: "dB(SPL)",
            system: unitsOfMeasureCodingSystemUrl,
            code: "dB(SPL)"
        )
    )
    
    fileprivate static let maximumLightIntensity = HKQuantitySampleMapping(
        codings: [
            MappedCode(
                code: "HKMetadataKeyMaximumLightIntensity",
                display: "Maximum Light Intensity",
                system: healthKitCodingSystemUrl
            )
        ],
        unit: MappedUnit(
            hkunit: .lux(),
            unit: "lux",
            system: unitsOfMeasureCodingSystemUrl,
            code: "lux"
        )
    )
}
