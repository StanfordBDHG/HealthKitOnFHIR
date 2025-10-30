//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import HealthKitOnFHIRMacros


@SynthesizeDisplayProperty("version1", "version2")
extension HKAppleECGAlgorithmVersion: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("preprandial", "postprandial")
extension HKBloodGlucoseMealTime: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty(
    "other", "armpit", "body", "ear", "finger", "gastroIntestinal",
    "mouth", "rectum", "toe", "earDrum", "temporalArtery", "forehead"
)
extension HKBodyTemperatureSensorLocation: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("maxExercise60Minute", "maxExercise20Minute", "rampTest", "predictionExercise")
extension HKCyclingFunctionalThresholdPowerTestType: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("unknown", "left", "right", "central")
extension HKDevicePlacementSide: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("notSet", "sedentary", "active")
extension HKHeartRateMotionContext: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("maxExercise", "predictionSubMaxExercise", "predictionNonExercise")
extension HKHeartRateRecoveryTestType: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("other", "chest", "wrist", "finger", "hand", "earLobe", "foot")
extension HKHeartRateSensorLocation: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("basal", "bolus")
extension HKInsulinDeliveryReason: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("activityLookup", "deviceSensed")
extension HKPhysicalEffortEstimationType: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("unknown", "mixed", "freestyle", "backstroke", "breaststroke", "butterfly", "kickboard")
extension HKSwimmingStrokeStyle: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("notSet", "stationary", "active")
extension HKUserMotionContext: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("maxExercise", "predictionSubMaxExercise", "predictionNonExercise", "predictionStepTest")
extension HKVO2MaxTestType: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("freshWater", "saltWater")
extension HKWaterSalinity: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty(
    "none", "clear", "fair", "partlyCloudy", "mostlyCloudy", "cloudy", "foggy", "haze",
    "windy", "blustery", "smoky", "dust", "snow", "hail", "sleet", "freezingDrizzle",
    "freezingRain", "mixedRainAndHail", "mixedRainAndSnow", "mixedRainAndSleet", "mixedSnowAndSleet",
    "drizzle", "scatteredShowers", "showers", "thunderstorms", "tropicalStorm", "hurricane", "tornado"
)
extension HKWeatherCondition: FHIRCodingConvertibleHKEnum {}

@SynthesizeDisplayProperty("unknown", "pool", "openWater")
extension HKWorkoutSwimmingLocationType: FHIRCodingConvertibleHKEnum {}
