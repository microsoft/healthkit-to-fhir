//
//  OxygenSaturationConversionTests.swift
//  HealthKitToFhir_Tests
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation

import Foundation
import Quick
import Nimble
import HealthKit
import FHIR

class OxygenSaturationConversionSpec : QuickSpec {
    override func spec() {
        describe("an oxygen saturation sample conversion") {
            context("the output FHIR Observation") {
                let expectedDate = Date.init(timeIntervalSince1970: 0)
                
                let sample = HKQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: .oxygenSaturation)!, quantity: HKQuantity(unit: HKUnit(from: "%"), doubleValue: 98), start: expectedDate, end: expectedDate)
                
                let expectedCoding1 = Coding()
                expectedCoding1.code = FHIRString("2708-6")
                expectedCoding1.display = FHIRString("Oxygen saturation in Arterial blood")
                expectedCoding1.system = FHIRURL("http://loinc.org")
                
                let expectedCoding2 = Coding()
                expectedCoding2.code = FHIRString("59408-5")
                expectedCoding2.display = FHIRString("Oxygen saturation in Arterial blood by Pulse oximetry")
                expectedCoding2.system = FHIRURL("http://loinc.org")
                
                let expectedIdentifier = Identifier()
                expectedIdentifier.system = FHIRURL("com.apple.health")
                expectedIdentifier.value = FHIRString(sample.uuid.uuidString)
                
                context("when using the default config") {
                    let observationFactory = try? ObservationFactory()
                    let observation = try! observationFactory!.observation(from: sample)
                    
                    itBehavesLike("observation resource") { ["observation" : observation,
                                                             "codings" : [expectedCoding1, expectedCoding2],
                                                             "effectiveDateTime" : expectedDate,
                                                             "identifers" : [expectedIdentifier]]
                    }
                    it("includes the expected value") {
                        if let value = observation.valueQuantity{
                            expect(value.value) == 98
                            expect(value.code) == "%"
                            expect(value.unit) == "%"
                            expect(value.system?.absoluteString) == "http://unitsofmeasure.org"
                        } else {
                            fail()
                        }
                    }
                    
                    context("when calling the generic resource method") {
                        let observation: Observation = try! observationFactory!.resource(from: sample)
                        
                        itBehavesLike("observation resource") { ["observation" : observation,
                                                                 "codings" : [expectedCoding1, expectedCoding2],
                                                                 "effectiveDateTime" : expectedDate,
                                                                 "identifers" : [expectedIdentifier]]
                        }
                        it("includes the expected value") {
                            if let value = observation.valueQuantity{
                                expect(value.value) == 98
                                expect(value.code) == "%"
                                expect(value.unit) == "%"
                                expect(value.system?.absoluteString) == "http://unitsofmeasure.org"
                            } else {
                                fail()
                            }
                        }
                        
                        context("The incorrect type is used") {
                            it("throws an error") {
                                expect {
                                    let observation: Device? = try observationFactory?.resource(from: sample)
                                    return observation
                                    }.to(throwError(ConversionError.incorrectTypeForFactory))
                            }
                        }
                    }
                }
            }
        }
    }
}
