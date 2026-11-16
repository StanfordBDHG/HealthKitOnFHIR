//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import HealthKit


/// Mappings for the `HKQuantity` values that HealthKit stores in sample metadata, used by the ``FHIRExtensionBuilder/metadata`` extension builder.
extension HKQuantitySampleMapping {
    private static let healthKitCodingSystemUrl = URL(string: "http://developer.apple.com/documentation/healthkit")!
    private static let unitsOfMeasureCodingSystemUrl = URL(string: "http://unitsofmeasure.org")!
    
    static let weatherTemperature = HKQuantitySampleMapping(
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
    
    static let weatherHumidity = HKQuantitySampleMapping(
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
    
    static let heartRateRecoveryActivityDuration = HKQuantitySampleMapping(
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
    
    static let heartRateRecoveryMaxObservedRecoveryHeartRate = HKQuantitySampleMapping( // swiftlint:disable:this identifier_name
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
    
    static let averageSpeed = HKQuantitySampleMapping(
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
    
    static let maximumSpeed = HKQuantitySampleMapping(
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
    
    static let alpineSlopeGrade = HKQuantitySampleMapping(
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
    
    static let elevationAscended = HKQuantitySampleMapping(
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
    
    static let elevationDescended = HKQuantitySampleMapping(
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
    
    static let fitnessMachineDuration = HKQuantitySampleMapping(
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
    
    static let indoorBikeDistance = HKQuantitySampleMapping(
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
    
    static let crossTrainerDistance = HKQuantitySampleMapping(
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
    
    static let highHeartRateEventThreshold = HKQuantitySampleMapping(
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
    
    static let averageMETs = HKQuantitySampleMapping(
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
    
    static let audioExposureLevel = HKQuantitySampleMapping(
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
    
    static let audioExposureDuration = HKQuantitySampleMapping(
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
    
    static let barometricPressure = HKQuantitySampleMapping(
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
    
    static let vo2MaxValue = HKQuantitySampleMapping(
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
    
    static let lowCardioFitnessEventThreshold = HKQuantitySampleMapping(
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
    
    static let headphoneGain = HKQuantitySampleMapping(
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
    
    static let maximumLightIntensity = HKQuantitySampleMapping(
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
