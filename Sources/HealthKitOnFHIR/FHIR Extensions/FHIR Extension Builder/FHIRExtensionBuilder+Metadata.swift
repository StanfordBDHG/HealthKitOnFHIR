//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import FHIRModelsExtensions
import Foundation
import HealthKit
import ModelsR4


extension FHIRExtensionUrls {
    // SAFETY: this is in fact safe, since the FHIRPrimitive's `extension` property is empty.
    // As a result, the actual instance doesn't contain any mutable state, and since this is a let,
    // it also never can be mutated to contain any.
    /// Url of a FHIR Extension containing, if applicable, encoded metadata of the `HKObject` from which a FHIR `Observation` was created.
    nonisolated(unsafe) public static let metadata = "https://bdh.stanford.edu/fhir/defs/metadata".asFHIRURIPrimitive()!
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
                // HealthKit returns BOOL values as boolean NSNumbers, which are matched before other NSNumbers. Numbers that `Decimal` cannot
                // represent are skipped: infinity and NaN, which would encode as invalid JSON, and -infinity, which would silently become 0.
                let extensionValue: Extension.ValueX
                switch value {
                case let value as String:
                    extensionValue = .string(value.asFHIRStringPrimitive())
                case let value as NSNumber where CFGetTypeID(value) == CFBooleanGetTypeID():
                    extensionValue = .boolean(value.boolValue.asPrimitive())
                case let value as NSNumber:
                    if let type = Self.type(forMetadataKey: key), let value = type.init(rawValue: value.intValue) {
                        extensionValue = .coding(value.asCoding)
                    } else if value.doubleValue.isFinite && !value.decimalValue.isNaN {
                        extensionValue = .decimal(FHIRPrimitive(FHIRDecimal(value.decimalValue)))
                    } else {
                        continue
                    }
                case let value as Date:
                    extensionValue = .dateTime(FHIRPrimitive(try DateTime(date: value)))
                case let value as HKQuantity:
                    switch key {
                    case HKMetadataKeyWeatherTemperature:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .weatherTemperature))
                    case HKMetadataKeyWeatherHumidity:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .weatherHumidity))
                    case HKMetadataKeySessionEstimate:
                        guard let sample = object as? HKQuantitySample,
                              let mapping = HKQuantitySampleMapping.default[sample.quantityType] else {
                            continue // should be unreachable. skipping
                        }
                        extensionValue = .quantity(try value.buildQuantity(mapping: mapping))
                    case HKMetadataKeyHeartRateRecoveryActivityDuration:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .heartRateRecoveryActivityDuration))
                    case HKMetadataKeyHeartRateRecoveryMaxObservedRecoveryHeartRate:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .heartRateRecoveryMaxObservedRecoveryHeartRate))
                    case HKMetadataKeyAverageSpeed:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .averageSpeed))
                    case HKMetadataKeyMaximumSpeed:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .maximumSpeed))
                    case HKMetadataKeyAlpineSlopeGrade:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .alpineSlopeGrade))
                    case HKMetadataKeyElevationAscended:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .elevationAscended))
                    case HKMetadataKeyElevationDescended:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .elevationDescended))
                    case HKMetadataKeyFitnessMachineDuration:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .fitnessMachineDuration))
                    case HKMetadataKeyIndoorBikeDistance:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .indoorBikeDistance))
                    case HKMetadataKeyCrossTrainerDistance:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .crossTrainerDistance))
                    case HKMetadataKeyHeartRateEventThreshold:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .highHeartRateEventThreshold))
                    case HKMetadataKeyAverageMETs:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .averageMETs))
                    case HKMetadataKeyAudioExposureLevel:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .audioExposureLevel))
                    case HKMetadataKeyAudioExposureDuration:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .audioExposureDuration))
                    case HKMetadataKeyBarometricPressure:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .barometricPressure))
                    case HKMetadataKeyVO2MaxValue:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .vo2MaxValue))
                    case HKMetadataKeyLowCardioFitnessEventThreshold:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .lowCardioFitnessEventThreshold))
                    case HKMetadataKeyHeadphoneGain:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .headphoneGain))
                    case HKMetadataKeyMaximumLightIntensity:
                        extensionValue = .quantity(try value.buildQuantity(mapping: .maximumLightIntensity))
                    default:
                        print("Encountered unexpected HKQuantity metadata value for key '\(key)': \(value). Skipping.")
                        continue
                    }
                default:
                    print("Encountered unexpected HKSample metadata value of type \(Swift.type(of: value)), for key '\(key)': \(value). Skipping.")
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
    
    private static func type(forMetadataKey key: String) -> (any FHIRCodingConvertibleHKEnum.Type)? { // swiftlint:disable:this cyclomatic_complexity
        switch key {
        case HKMetadataKeyAppleECGAlgorithmVersion:
            HKAppleECGAlgorithmVersion.self
        case HKMetadataKeyBloodGlucoseMealTime:
            HKBloodGlucoseMealTime.self
        case HKMetadataKeyBodyTemperatureSensorLocation:
            HKBodyTemperatureSensorLocation.self
        case HKMetadataKeyCyclingFunctionalThresholdPowerTestType:
            HKCyclingFunctionalThresholdPowerTestType.self
        case HKMetadataKeyDevicePlacementSide:
            HKDevicePlacementSide.self
        case HKMetadataKeyHeartRateMotionContext:
            HKHeartRateMotionContext.self
        case HKMetadataKeyHeartRateRecoveryTestType:
            HKHeartRateRecoveryTestType.self
        case HKMetadataKeyHeartRateSensorLocation:
            HKHeartRateSensorLocation.self
        case HKMetadataKeyInsulinDeliveryReason:
            HKInsulinDeliveryReason.self
        case HKMetadataKeyPhysicalEffortEstimationType:
            HKPhysicalEffortEstimationType.self
        case HKMetadataKeySwimmingStrokeStyle:
            HKSwimmingStrokeStyle.self
        case HKMetadataKeyUserMotionContext:
            HKUserMotionContext.self
        case HKMetadataKeyVO2MaxTestType:
            HKVO2MaxTestType.self
        case HKMetadataKeyWaterSalinity:
            HKWaterSalinity.self
        case HKMetadataKeyWeatherCondition:
            HKWeatherCondition.self
        case HKMetadataKeySwimmingLocationType:
            HKWorkoutSwimmingLocationType.self
        default:
            nil
        }
    }
}
