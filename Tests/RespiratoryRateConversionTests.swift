//
//  RespiratoryRateConversionTests.swift
//  HealthKitToFhir_Tests
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import Quick
import Nimble
import HealthKit
import FHIR

class RespiratoryRateConversionSpec : QuickSpec {
    override func spec() {
        describe("a respiratory rate sample conversion") {
            context("the output FHIR Observation") {
                let expectedDate = Date.init(timeIntervalSince1970: 0)
                
                let sample = HKQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!, quantity: HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 20), start: expectedDate, end: expectedDate)
                
                let expectedCoding1 = Coding()
                expectedCoding1.code = FHIRString("9279-1")
                expectedCoding1.display = FHIRString("Respiratory rate")
                expectedCoding1.system = FHIRURL("http://loinc.org")
                
                let expectedCoding2 = Coding()
                expectedCoding2.code = FHIRString("HKQuantityTypeIdentifierRespiratoryRate")
                expectedCoding2.display = FHIRString("Respiratory rate")
                expectedCoding2.system = FHIRURL("com.apple.health")
                
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
                            expect(value.value) == 20
                            expect(value.code) == "/min"
                            expect(value.unit) == "count/min"
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
                                expect(value.value) == 20
                                expect(value.code) == "/min"
                                expect(value.unit) == "count/min"
                                expect(value.system?.absoluteString) == "http://unitsofmeasure.org"
                            } else {
                                fail()
                            }
                        }
                        
                        context("The incorrect type is used") {
                            it("throws an error") {
                                expect {
                                    let _: Device? = try observationFactory?.resource(from: sample)
                                }.to(throwError(ConversionError.incorrectTypeForFactory))
                            }
                        }
                    }
                }
            }
        }
    }
}
