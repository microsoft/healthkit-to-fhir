//
//  StepCountConversionTests.swift
//  HealthKitToFhir_Tests
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import Quick
import Nimble
import HealthKit
import FHIR

class StepCountConversionSpec : QuickSpec {
    override func spec() {
        describe("a step count sample conversion") {
            context("the output FHIR Observation") {
                let expectedStartDate = Date.init(timeIntervalSince1970: 0)
                let expectedEndDate = expectedStartDate.addingTimeInterval(TimeInterval(60))
                let sample = HKQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: .stepCount)!, quantity: HKQuantity(unit: HKUnit(from: "count"), doubleValue: 200), start: expectedStartDate, end: expectedEndDate)
                
                let expectedCoding = Coding()
                expectedCoding.code = FHIRString("55423-8")
                expectedCoding.display = FHIRString("Number of steps")
                expectedCoding.system = FHIRURL("http://loinc.org")
                
                let expectedIdentifier = Identifier()
                expectedIdentifier.system = FHIRURL("com.apple.health")
                expectedIdentifier.value = FHIRString(sample.uuid.uuidString)
                
                let expectedPeriod = Period()
                expectedPeriod.start = expectedStartDate.fhir_asDateTime()
                expectedPeriod.end = expectedEndDate.fhir_asDateTime()
                
                context("when using the default config") {
                    let observationFactory = try? ObservationFactory()
                    let observation = try! observationFactory!.observation(from: sample)
                    
                    itBehavesLike("observation resource") { ["observation" : observation,
                                                             "codings" : [expectedCoding],
                                                             "effectivePeriod" : expectedPeriod,
                                                             "identifers" : [expectedIdentifier]]
                    }
                    it("includes the expected value") {
                        if let value = observation.valueQuantity{
                            expect(value.value) == 200
                            expect(value.code) == "{tot}"
                            expect(value.unit) == "count"
                            expect(value.system?.absoluteString) == "http://unitsofmeasure.org"
                        } else {
                            fail()
                        }
                    }
                    
                    context("when calling the generic resource method") {
                        let observation: Observation = try! observationFactory!.resource(from: sample)
                        
                        itBehavesLike("observation resource") { ["observation" : observation,
                                                                 "codings" : [expectedCoding],
                                                                 "effectivePeriod" : expectedPeriod,
                                                                 "identifers" : [expectedIdentifier]]
                        }
                        it("includes the expected value") {
                            if let value = observation.valueQuantity{
                                expect(value.value) == 200
                                expect(value.code) == "{tot}"
                                expect(value.unit) == "count"
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
