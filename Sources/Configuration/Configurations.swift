//
//  Configurations.swift
//  HealthKitToFhir
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

/// This class is auto-generated. Edits to this file will be overwritten during the build process.
/// To make changes to the default configuration, edit the DefaultObservationFactoryConfig.json file.
internal struct Configurations {
    internal static let defaultConfig = "{    \"HKQuantityTypeIdentifierHeartRate\": {        \"code\": {            \"coding\": [                {                    \"system\" : \"http://loinc.org\",                    \"code\": \"8867-4\",                    \"display\": \"Heart rate\"                },                {                    \"system\" : \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierHeartRate\",                    \"display\": \"Heart rate\"                }            ]        },        \"valueQuantity\" : {            \"unit\" : \"count/min\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"/min\"        }    },    \"HKCorrelationTypeIdentifierBloodPressure\": {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"85354-9\",                    \"display\": \"Blood pressure panel\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKCorrelationTypeIdentifierBloodPressure\",                    \"display\": \"Blood pressure panel\"                }            ]        }    },    \"HKQuantityTypeIdentifierBloodPressureDiastolic\": {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"8462-4\",                    \"display\": \"Diastolic blood pressure\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierBloodPressureDiastolic\",                    \"display\": \"Diastolic blood pressure\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"mmHg\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"mmHg\"        }    },    \"HKQuantityTypeIdentifierBloodPressureSystolic\": {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"8480-6\",                    \"display\": \"Systolic blood pressure\"                },                {                    \"system\": \"http://snomed.info/sct\",                    \"code\": \"271649006\",                    \"display\": \"Systolic blood pressure\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierBloodPressureSystolic\",                    \"display\": \"Systolic blood pressure\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"mmHg\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"mmHg\"        }    },    \"HKQuantityTypeIdentifierStepCount\": {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"55423-8\",                    \"display\": \"Number of steps\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierStepCount\",                    \"display\": \"Number of steps\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"count\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"{tot}\"        }    },    \"HKQuantityTypeIdentifierBloodGlucose\": {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"41653-7\",                    \"display\": \"Glucose Glucometer (BldC) [Mass/Vol]\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierBloodGlucose\",                    \"display\": \"Glucose Glucometer (BldC) [Mass/Vol]\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"mg/dL\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"mg/dL\"        }    },    \"HKQuantityTypeIdentifierOxygenSaturation\": {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"2708-6\",                    \"display\": \"Oxygen saturation in Arterial blood\"                },                {                    \"system\": \"http://loinc.org\",                    \"code\": \"59408-5\",                    \"display\": \"Oxygen saturation in Arterial blood by Pulse oximetry\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierOxygenSaturation\",                    \"display\": \"Oxygen saturation in Arterial blood by Pulse oximetry\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"%\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"%\"        }    },    \"HKQuantityTypeIdentifierBodyMass\": {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"29463-7\",                    \"display\": \"Body weight\"                },                {                    \"system\": \"http://loinc.org\",                    \"code\": \"3141-9\",                    \"display\": \"Body weight measured\"                },                {                    \"system\": \"http://snomed.info/sct\",                    \"code\": \"27113001\",                    \"display\": \"Body weight\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierBodyMass\",                    \"display\": \"Body weight\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"kg\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"kg\"        }    },    \"HKQuantityTypeIdentifierBodyTemperature\": {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"8310-5\",                    \"display\": \"Body temperature\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierBodyTemperature\",                    \"display\": \"Body temperature\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"degC\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"Cel\"        }    },    \"HKQuantityTypeIdentifierRespiratoryRate\": {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"9279-1\",                    \"display\": \"Respiratory rate\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierRespiratoryRate\",                    \"display\": \"Respiratory rate\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"count/min\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"/min\"        }    },    \"HKQuantityTypeIdentifierHeight\" : {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"8302-2\",                    \"display\": \"Body height\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierHeight\",                    \"display\": \"Body height\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"cm\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"cm\"        }    },    \"HKQuantityTypeIdentifierActiveEnergyBurned\" : {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"41981-2\",                    \"display\": \"Calories burned\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierActiveEnergyBurned\",                    \"display\": \"Calories burned\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"kcal\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"kcal\"        }    },    \"HKQuantityTypeIdentifierAppleExerciseTime\" : {        \"code\": {            \"coding\": [                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierAppleExerciseTime\",                    \"display\": \"Apple Exercise Time\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"ms\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"ms\"        }    },    \"HKQuantityTypeIdentifierAppleStandTime\" : {        \"code\": {            \"coding\": [                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierAppleStandTime\",                    \"display\": \"Apple Stand Time\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"ms\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"ms\"        }    },    \"HKQuantityTypeIdentifierDietaryEnergyConsumed\" : {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"9052-2\",                    \"display\": \"Calorie intake total\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierDietaryEnergyConsumed\",                    \"display\": \"Calorie intake total\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"kcal\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"kcal\"        }    },    \"HKQuantityTypeIdentifierEnvironmentalAudioExposure\" : {        \"code\": {            \"coding\": [                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierEnvironmentalAudioExposure\",                    \"display\": \"Environmental Audio Exposure\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"dBASPL\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"B(SPL)\"        }    },    \"HKQuantityTypeIdentifierHeartRateVariabilitySDNN\" : {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"80404-7\",                    \"display\": \"R-R interval.standard deviation (Heart rate variability)\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierHeartRateVariabilitySDNN\",                    \"display\": \"Heart rate variability\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"ms\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"ms\"        }    },    \"HKQuantityTypeIdentifierRestingHeartRate\" : {        \"code\": {            \"coding\": [                {                    \"system\": \"http://loinc.org\",                    \"code\": \"40443-4\",                    \"display\": \"Heart rate --resting\"                },                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierRestingHeartRate\",                    \"display\": \"Resting Heart Rate\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"count/min\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"/min\"        }    },    \"HKQuantityTypeIdentifierWalkingHeartRateAverage\" : {        \"code\": {            \"coding\": [                {                    \"system\": \"com.apple.health\",                    \"code\": \"HKQuantityTypeIdentifierWalkingHeartRateAverage\",                    \"display\": \"Walking Heart Rate Average\"                }            ]        },        \"valueQuantity\": {            \"unit\" : \"count/min\",            \"system\" : \"http://unitsofmeasure.org\",            \"code\" : \"/min\"        }    }}"
}
