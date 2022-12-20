#
# This source file is part of the HealthKitOnFHIR open source project
#
# SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
#
# SPDX-License-Identifier: MIT
#

import json
from operator import itemgetter

# Constants
MAPPING_FILE_PATH = '../Sources/HealthKitOnFHIR/Resources/HKSampleMapping.json'
TOC_PATH = '../Documentation/SUPPORT_TABLE.md'
QUANTITY_TABLE_PATH = '../Documentation/QUANTITY_TABLE.md'
CATEGORY_TABLE_PATH = '../Documentation/CATEGORY_TABLE.md'
CORRELATION_TABLE_PATH = '../Documentation/CORRELATION_TABLE.md'

HEALTHKIT_URL = 'https://developer.apple.com/documentation/healthkit'
LOINC_URL = 'http://loinc.org'

SUPPORTED_SYMBOL = ':white_check_mark:'
UNSUPPORTED_SYMBOL = ':x:'

ALL_QUANTITY_TYPES = [
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
    "HKQuantityTypeIdentifierDietaryFatTotal",
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

ALL_CORRELATION_TYPES = [
    "HKCorrelationTypeIdentifierBloodPressure",
    "HKCorrelationTypeIdentifierFood"
]

ALL_CATEGORY_TYPES = [
    "HKCategoryTypeIdentifierAppetiteChanges",
    "HKCategoryTypeIdentifierAppleStandHour",
    "HKCategoryTypeIdentifierAppleWalkingSteadinessEvent",
    "HKCategoryTypeIdentifierCervicalMucusQuality",
    "HKCategoryTypeIdentifierContraceptive",
    "HKCategoryTypeIdentifierAudioExposureEvent",
    "HKCategoryTypeIdentifierHeadphoneAudioExposureEvent",
    "HKCategoryTypeIdentifierLowCardioFitnessEvent",
    "HKCategoryTypeIdentifierMenstrualFlow",
    "HKCategoryTypeIdentifierOvulationTestResult",
    "HKCategoryTypeIdentifierPregnancyTestResult",
    "HKCategoryTypeIdentifierProgesteroneTestResult",
    "HKCategoryTypeIdentifierSleepAnalysis",
    "HKCategoryTypeIdentifierAbdominalCramps",
    "HKCategoryTypeIdentifierAcne",
    "HKCategoryTypeIdentifierBladderIncontinence",
    "HKCategoryTypeIdentifierBloating",
    "HKCategoryTypeIdentifierBreastPain",
    "HKCategoryTypeIdentifierChestTightnessOrPain",
    "HKCategoryTypeIdentifierChills",
    "HKCategoryTypeIdentifierConstipation",
    "HKCategoryTypeIdentifierCoughing",
    "HKCategoryTypeIdentifierDizziness",
    "HKCategoryTypeIdentifierDrySkin",
    "HKCategoryTypeIdentifierFainting",
    "HKCategoryTypeIdentifierFever",
    "HKCategoryTypeIdentifierGeneralizedBodyAche",
    "HKCategoryTypeIdentifierHairLoss",
    "HKCategoryTypeIdentifierHeadache",
    "HKCategoryTypeIdentifierHeartburn",
    "HKCategoryTypeIdentifierHotFlashes",
    "HKCategoryTypeIdentifierLossOfSmell",
    "HKCategoryTypeIdentifierLossOfTaste",
    "HKCategoryTypeIdentifierLowerBackPain",
    "HKCategoryTypeIdentifierMemoryLapse",
    "HKCategoryTypeIdentifierNausea",
    "HKCategoryTypeIdentifierNightSweats",
    "HKCategoryTypeIdentifierPelvicPain",
    "HKCategoryTypeIdentifierRapidPoundingOrFlutteringHeartbeat",
    "HKCategoryTypeIdentifierRunnyNose",
    "HKCategoryTypeIdentifierShortnessOfBreath",
    "HKCategoryTypeIdentifierSinusCongestion",
    "HKCategoryTypeIdentifierSkippedHeartbeat",
    "HKCategoryTypeIdentifierSoreThroat",
    "HKCategoryTypeIdentifierVaginalDryness",
    "HKCategoryTypeIdentifierVomiting",
    "HKCategoryTypeIdentifierWheezing",
    "HKCategoryTypeIdentifierMoodChanges",
    "HKCategoryTypeIdentifierSleepChanges",
    "HKCategoryTypeIdentifierIrregularHeartRhythmEvent",
    "HKCategoryTypeIdentifierLowHeartRateEvent",
    "HKCategoryTypeIdentifierHighHeartRateEvent",
    "HKCategoryTypeIdentifierMindfulSession",
    "HKCategoryTypeIdentifierToothbrushingEvent",
    "HKCategoryTypeIdentifierHandwashingEvent",
    "HKCategoryTypeIdentifierSexualActivity",
    "HKCategoryTypeIdentifierIntermenstrualBleeding",
    "HKCategoryTypeIdentifierInfrequentMenstrualCycles",
    "HKCategoryTypeIdentifierIrregularMenstrualCycles",
    "HKCategoryTypeIdentifierPersistentIntermenstrualBleeding",
    "HKCategoryTypeIdentifierProlongedMenstrualPeriods",
    "HKCategoryTypeIdentifierLactation"
]

# Load data
mapping_file = open(MAPPING_FILE_PATH)
data = json.load(mapping_file)
toc_file = open(TOC_PATH, 'w')
quantity_file = open(QUANTITY_TABLE_PATH, 'w')
category_file = open(CATEGORY_TABLE_PATH, 'w')
correlation_file = open(CORRELATION_TABLE_PATH, 'w')

quantity_stats_string = ""
category_stats_string = ""
correlation_stats_string = ""

def create_header():
    return """<!--
                  
This source file is part of the HealthKitOnFHIR open source project

SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
             
-->
"""

def create_code_links(type, types):
        coding = types[type]['codings'][0]
        code = coding['code']
        code_system = types[type]['codings'][0]['system']

        if code_system == LOINC_URL or code_system == HEALTHKIT_URL:
            # the {url}/{code} structure works for these code systems
            code_url = '{}/{}'.format(code_system, code)
        else:
            code_url = code_system

        return '[{}]({})'.format(code, code_url)

def create_quantity_types_table():
    markdown = '# HKQuantityType\n\n'

    quantity_types = data['HKQuantitySamples']
    rows = []

    for type in quantity_types:    
        # Format code links
        linked_code = create_code_links(type, quantity_types)

        # Format unit links
        unit_coding = quantity_types[type]['unit']
        unit = unit_coding['unit']
        if 'system' in unit_coding: # Some units are not from a code system
            linked_unit = '[{}]({})'.format(unit, unit_coding['system'])
        else:
            linked_unit = unit
        
        row = [type, SUPPORTED_SYMBOL, linked_code, linked_unit]
        rows.append(row)

    # Add all the unsupported types
    for type in ALL_QUANTITY_TYPES:
        if type not in quantity_types:
            rows.append([type, UNSUPPORTED_SYMBOL, "-", "-"])

    # Sort the rows alphabetically
    rows = sorted(rows, key=itemgetter(0))

    # Link all the HealthKit types to Apple docs
    for type in rows:
        url = '{}/{}'.format(HEALTHKIT_URL, type[0])
        type[0] = '[{}]({})'.format(type[0].removeprefix('HKQuantityTypeIdentifier'), url)

    # Add the statistics
    global quantity_stats_string
    quantity_stats_string = 'HealthKitOnFHIR supports {} of {} quantity types.'.format(len(quantity_types), len(rows))
    markdown += quantity_stats_string + '\n\n'

    # Add the table header
    markdown += '|HKQuantityType|Supported|Code|Unit|' + '\n' + '|----|----|----|----|' + '\n'

    # Add all rows
    for row in rows:
        markdown += '|' + '|'.join(row) + '|\n'

    return markdown

def create_correlation_types_table():
    markdown = '# HKCorrelationType\n\n'

    correlation_types = data['HKCorrelations']
    rows = []

    for type in correlation_types:    
        # Format code links
        linked_code = create_code_links(type, correlation_types)
        
        row = [type, SUPPORTED_SYMBOL, linked_code]
        rows.append(row)

    # Add all the unsupported types
    for type in ALL_CORRELATION_TYPES:
        if type not in correlation_types:
            rows.append([type, UNSUPPORTED_SYMBOL, "-"])

    # Sort the rows alphabetically
    rows = sorted(rows, key=itemgetter(0))

    # Link all the HealthKit types to Apple docs
    for type in rows:
        url = '{}/{}'.format(HEALTHKIT_URL, type[0])
        type[0] = '[{}]({})'.format(type[0].removeprefix('HKCorrelationTypeIdentifier'), url)

    # Add the statistics
    global correlation_stats_string
    correlation_stats_string = 'HealthKitOnFHIR supports {} of {} correlation types.'.format(len(correlation_types), len(rows))
    markdown += correlation_stats_string + '\n\n'

    # Add the table header
    markdown += '|HKCorrelationType|Supported|Code|' + '\n' + '|----|----|----|' + '\n'

    # Add all rows
    for row in rows:
        markdown += '|' + '|'.join(row) + '|\n'

    return markdown

def create_category_types_table():
    markdown = '# HKCategoryType\n\n'

    category_types = data['HKCategorySamples']
    rows = []

    for type in category_types:
        row = [type, SUPPORTED_SYMBOL]
        rows.append(row)

    # Add all the unsupported types
    for type in ALL_CATEGORY_TYPES:
        if type not in category_types:
            rows.append([type, UNSUPPORTED_SYMBOL, "-"])

    # Sort the rows alphabetically
    rows = sorted(rows, key=itemgetter(0))

    # Link all the HealthKit types to Apple docs
    for type in rows:
        url = '{}/{}'.format(HEALTHKIT_URL, type[0])
        type[0] = '[{}]({})'.format(type[0].removeprefix('HKCategoryTypeIdentifier'), url)

    # Add the statistics
    global category_stats_string
    category_stats_string = 'HealthKitOnFHIR supports {} of {} category types.'.format(len(category_types), len(rows))
    markdown += category_stats_string + '\n\n'

    # Add the table header
    markdown += '|HKCategoryType|Supported|' + '\n' + '|----|----|' + '\n'

    # Add all rows
    for row in rows:
        markdown += '|' + '|'.join(row) + '|\n'

    return markdown

def create_toc():
    markdown = '# HKObject Support Tables \n\n'

    markdown += """
- [HKCategoryType](CATEGORY_TABLE.md)
    - {}
- [HKCorrelation](CORRELATION_TABLE.md)
    - {}
- [HKQuantityType](QUANTITY_TABLE.md)
    - {}
    """.format(category_stats_string, correlation_stats_string, quantity_stats_string)

    return markdown

def main():
    category_file.write(create_header() + create_category_types_table())
    quantity_file.write(create_header() + create_quantity_types_table())
    correlation_file.write(create_header() + create_correlation_types_table())
    toc_file.write(create_header() + create_toc())

if __name__ == "__main__":
    main()
