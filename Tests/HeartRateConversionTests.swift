//
//  HeartRateConversionTests.swift
//  HealthKitToFhir_Tests
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import Quick
import Nimble
import HealthKit
import FHIR

class HeartRateConversionSpec : QuickSpec {
    override func spec() {
        describe("a heart rate sample conversion") {
            context("the output FHIR Observation") {
                let expectedDate = Date.init(timeIntervalSince1970: 0)
                
                let sample = HKQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: .heartRate)!, quantity: HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 70), start: expectedDate, end: expectedDate)
                
                let expectedCoding = Coding()
                expectedCoding.code = FHIRString("8867-4")
                expectedCoding.display = FHIRString("Heart rate")
                expectedCoding.system = FHIRURL("http://loinc.org")
                
                let expectedIdentifier = Identifier()
                expectedIdentifier.system = FHIRURL("com.apple.health")
                expectedIdentifier.value = FHIRString(sample.uuid.uuidString)
                
                context("when using the default config") {
                    let observationFactory = try? ObservationFactory()
                    let observation = try! observationFactory!.observation(from: sample)
                    
                    itBehavesLike("observation resource") { ["observation" : observation,
                                                             "codings" : [expectedCoding],
                                                             "effectiveDateTime" : expectedDate,
                                                             "identifers" : [expectedIdentifier]]
                    }
                    it("includes the expected value") {
                        if let value = observation.valueQuantity{
                            expect(value.value) == 70
                            expect(value.code) == "{beats}/min"
                            expect(value.unit) == "count/min"
                            expect(value.system?.absoluteString) == "http://unitsofmeasure.org"
                        } else {
                            fail()
                        }
                    }
                    
                    context("when calling the generic resource method") {
                        let observation: Observation = try! observationFactory!.resource(from: sample)
                        
                        itBehavesLike("observation resource") { ["observation" : observation,
                                                                 "codings" : [expectedCoding],
                                                                 "effectiveDateTime" : expectedDate,
                                                                 "identifers" : [expectedIdentifier]]
                        }
                        it("includes the expected value") {
                            if let value = observation.valueQuantity{
                                expect(value.value) == 70
                                expect(value.code) == "{beats}/min"
                                expect(value.unit) == "count/min"
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
