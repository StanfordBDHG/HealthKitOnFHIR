#
# This source file is part of the HealthKitOnFHIR open source project
#
# SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#

import json
from snakemd import Document
from operator import itemgetter

all_quantity_types = [
    "HKQuantityTypeIdentifierActiveEnergyBurned",
    "HKQuantityTypeIdentifierAppleExerciseTime",
    "HKQuantityTypeIdentifierBasalBodyTemperature",
    "HKQuantityTypeIdentifierBasalEnergyBurned",
    "HKQuantityTypeIdentifierBloodAlcoholContent",
    "HKQuantityTypeIdentifierBloodGlucose",
    "HKQuantityTypeIdentifierBloodPressureDiastolic",
    "HKQuantityTypeIdentifierBloodPressureSystolic",
    "HKQuantityTypeIdentifierBodyFatPercentage",
    "HKQuantityTypeIdentifierBodyMass",
    "HKQuantityTypeIdentifierBodyMassIndex",
    "HKQuantityTypeIdentifierBodyTemperature",
    "HKQuantityTypeIdentifierDietaryBiotin",
    "HKQuantityTypeIdentifierDietaryCaffeine",
    "HKQuantityTypeIdentifierDietaryCalcium",
    "HKQuantityTypeIdentifierDietaryCarbohydrates",
    "HKQuantityTypeIdentifierDietaryChloride",
    "HKQuantityTypeIdentifierDietaryCholesterol",
    "HKQuantityTypeIdentifierDietaryChromium",
    "HKQuantityTypeIdentifierDietaryCopper",
    "HKQuantityTypeIdentifierDietaryEnergyConsumed",
    "HKQuantityTypeIdentifierDietaryFatMonounsaturated",
    "HKQuantityTypeIdentifierDietaryFatPolyunsaturated",
    "HKQuantityTypeIdentifierDietaryFatSaturated",
    "HKQuantityTypeIdentifierDietaryFatTotal"
    "HKQuantityTypeIdentifierDietaryFiber",
    "HKQuantityTypeIdentifierDietaryFolate",
    "HKQuantityTypeIdentifierDietaryIodine",
    "HKQuantityTypeIdentifierDietaryIron",
    "HKQuantityTypeIdentifierDietaryMagnesium",
    "HKQuantityTypeIdentifierDietaryManganese",
    "HKQuantityTypeIdentifierDietaryMolybdenum",
    "HKQuantityTypeIdentifierDietaryNiacin",
    "HKQuantityTypeIdentifierDietaryPantothenicAcid",
    "HKQuantityTypeIdentifierDietaryPhosphorus",
    "HKQuantityTypeIdentifierDietaryPotassium",
    "HKQuantityTypeIdentifierDietaryProtein",
    "HKQuantityTypeIdentifierDietaryRiboflavin",
    "HKQuantityTypeIdentifierDietarySelenium",
    "HKQuantityTypeIdentifierDietarySodium",
    "HKQuantityTypeIdentifierDietarySugar",
    "HKQuantityTypeIdentifierDietaryThiamin",
    "HKQuantityTypeIdentifierDietaryVitaminA",
    "HKQuantityTypeIdentifierDietaryVitaminB12",
    "HKQuantityTypeIdentifierDietaryVitaminB6",
    "HKQuantityTypeIdentifierDietaryVitaminC",
    "HKQuantityTypeIdentifierDietaryVitaminD",
    "HKQuantityTypeIdentifierDietaryVitaminE",
    "HKQuantityTypeIdentifierDietaryVitaminK",
    "HKQuantityTypeIdentifierDietaryWater",
    "HKQuantityTypeIdentifierDietaryZinc",
    "HKQuantityTypeIdentifierDistanceCycling",
    "HKQuantityTypeIdentifierDistanceDownhillSnowSports",
    "HKQuantityTypeIdentifierDistanceSwimming",
    "HKQuantityTypeIdentifierDistanceWalkingRunning",
    "HKQuantityTypeIdentifierDistanceWheelchair",
    "HKQuantityTypeIdentifierElectrodermalActivity",
    "HKQuantityTypeIdentifierFlightsClimbed",
    "HKQuantityTypeIdentifierForcedExpiratoryVolume1",
    "HKQuantityTypeIdentifierForcedVitalCapacity",
    "HKQuantityTypeIdentifierHeartRate",
    "HKQuantityTypeIdentifierHeartRateVariabilitySDNN",
    "HKQuantityTypeIdentifierHeight",
    "HKQuantityTypeIdentifierInhalerUsage",
    "HKQuantityTypeIdentifierInsulinDelivery",
    "HKQuantityTypeIdentifierLeanBodyMass",
    "HKQuantityTypeIdentifierNikeFuel",
    "HKQuantityTypeIdentifierNumberOfTimesFallen",
    "HKQuantityTypeIdentifierOxygenSaturation",
    "HKQuantityTypeIdentifierPeakExpiratoryFlowRate",
    "HKQuantityTypeIdentifierPeripheralPerfusionIndex",
    "HKQuantityTypeIdentifierPushCount",
    "HKQuantityTypeIdentifierRespiratoryRate",
    "HKQuantityTypeIdentifierRestingHeartRate",
    "HKQuantityTypeIdentifierStepCount",
    "HKQuantityTypeIdentifierSwimmingStrokeCount",
    "HKQuantityTypeIdentifierUVExposure",
    "HKQuantityTypeIdentifierVO2Max",
    "HKQuantityTypeIdentifierWaistCircumference",
    "HKQuantityTypeIdentifierWalkingHeartRateAverage"
]

mapping_file = open('Sources/HealthKitOnFHIR/Resources/HKSampleMapping.json')

data = json.load(mapping_file)

doc = Document("SUPPORT_TABLE")

doc.add_header("HKObject Support Table")

quantity_types = data["HKQuantitySamples"]

rows = []

# Add all the supported types
for type in quantity_types:
    formatted_type = type.removeprefix("HKQuantityTypeIdentifier")
    row = [formatted_type, ":white_check_mark:", quantity_types[type]["codings"][0]["code"], quantity_types[type]["unit"]["unit"]]
    rows.append(row)

# Add all the unsupported types
for type in all_quantity_types:
    if type not in quantity_types:
        formatted_type = type.removeprefix("HKQuantityTypeIdentifier")
        rows.append([formatted_type, ":x:", "-", "-"])

# Sort the rows alphabetically
rows = sorted(rows, key=itemgetter(0))

doc.add_paragraph(
    'HealthKitOnFHIR supports {} of {} quantity types.'.format(len(quantity_types), len(all_quantity_types))
)

doc.add_table(
    ["HKQuantityType", "Supported", "Code", "Unit"],
    rows
)

doc.output_page()