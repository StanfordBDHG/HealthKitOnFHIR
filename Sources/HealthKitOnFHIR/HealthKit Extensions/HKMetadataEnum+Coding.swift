//
// This source file is part of the HealthKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import HealthKit
import HealthKitOnFHIRMacros


@EnumCases("version1", "version2")
extension HKAppleECGAlgorithmVersion: FHIRCodingConvertibleHKEnum {}

@EnumCases("preprandial", "postprandial")
extension HKBloodGlucoseMealTime: FHIRCodingConvertibleHKEnum {}

@EnumCases(
    "other", "armpit", "body", "ear", "finger", "gastroIntestinal",
    "mouth", "rectum", "toe", "earDrum", "temporalArtery", "forehead"
)
extension HKBodyTemperatureSensorLocation: FHIRCodingConvertibleHKEnum {}

@EnumCases("maxExercise60Minute", "maxExercise20Minute", "rampTest", "predictionExercise")
extension HKCyclingFunctionalThresholdPowerTestType: FHIRCodingConvertibleHKEnum {}

@EnumCases("unknown", "left", "right", "central")
extension HKDevicePlacementSide: FHIRCodingConvertibleHKEnum {}

@EnumCases("notSet", "sedentary", "active")
extension HKHeartRateMotionContext: FHIRCodingConvertibleHKEnum {}

@EnumCases("maxExercise", "predictionSubMaxExercise", "predictionNonExercise")
extension HKHeartRateRecoveryTestType: FHIRCodingConvertibleHKEnum {}

@EnumCases("other", "chest", "wrist", "finger", "hand", "earLobe", "foot")
extension HKHeartRateSensorLocation: FHIRCodingConvertibleHKEnum {}

@EnumCases("basal", "bolus")
extension HKInsulinDeliveryReason: FHIRCodingConvertibleHKEnum {}

@EnumCases("activityLookup", "deviceSensed")
extension HKPhysicalEffortEstimationType: FHIRCodingConvertibleHKEnum {}

@EnumCases("unknown", "mixed", "freestyle", "backstroke", "breaststroke", "butterfly", "kickboard")
extension HKSwimmingStrokeStyle: FHIRCodingConvertibleHKEnum {}

@EnumCases("notSet", "stationary", "active")
extension HKUserMotionContext: FHIRCodingConvertibleHKEnum {}

@EnumCases("maxExercise", "predictionSubMaxExercise", "predictionNonExercise", "predictionStepTest")
extension HKVO2MaxTestType: FHIRCodingConvertibleHKEnum {}

@EnumCases("freshWater", "saltWater")
extension HKWaterSalinity: FHIRCodingConvertibleHKEnum {}

@EnumCases(
    "none", "clear", "fair", "partlyCloudy", "mostlyCloudy", "cloudy", "foggy", "haze",
    "windy", "blustery", "smoky", "dust", "snow", "hail", "sleet", "freezingDrizzle",
    "freezingRain", "mixedRainAndHail", "mixedRainAndSnow", "mixedRainAndSleet", "mixedSnowAndSleet",
    "drizzle", "scatteredShowers", "showers", "thunderstorms", "tropicalStorm", "hurricane", "tornado"
)
extension HKWeatherCondition: FHIRCodingConvertibleHKEnum {}

@EnumCases("unknown", "pool", "openWater")
extension HKWorkoutSwimmingLocationType: FHIRCodingConvertibleHKEnum {}
