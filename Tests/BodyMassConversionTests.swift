//
//  BodyMassConversionTests.swift
//  HealthKitToFhir_Tests
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import Quick
import Nimble
import HealthKit
import FHIR

class BodyMassConversionSpec : QuickSpec {
    override func spec() {
        describe("a body mass sample conversion") {
            context("the output FHIR Observation") {
                let expectedDate = Date.init(timeIntervalSince1970: 0)
                
                let sample = HKQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: .bodyMass)!, quantity: HKQuantity(unit: HKUnit(from: "kg"), doubleValue: 80), start: expectedDate, end: expectedDate)
                
                let expectedCoding1 = Coding()
                expectedCoding1.code = FHIRString("29463-7")
                expectedCoding1.display = FHIRString("Body weight")
                expectedCoding1.system = FHIRURL("http://loinc.org")
                
                let expectedCoding2 = Coding()
                expectedCoding2.code = FHIRString("3141-9")
                expectedCoding2.display = FHIRString("Body weight measured")
                expectedCoding2.system = FHIRURL("http://loinc.org")
                
                let expectedCoding3 = Coding()
                expectedCoding3.code = FHIRString("27113001")
                expectedCoding3.display = FHIRString("Body weight")
                expectedCoding3.system = FHIRURL("http://snomed.info/sct")
                
                let expectedIdentifier = Identifier()
                expectedIdentifier.system = FHIRURL("com.apple.health")
                expectedIdentifier.value = FHIRString(sample.uuid.uuidString)
                
                context("when using the default config") {
                    let observationFactory = try? ObservationFactory()
                    let observation = try! observationFactory!.observation(from: sample)
                    
                    itBehavesLike("observation resource") { ["observation" : observation,
                                                             "codings" : [expectedCoding1, expectedCoding2, expectedCoding3],
                                                             "effectiveDateTime" : expectedDate,
                                                             "identifers" : [expectedIdentifier]]
                    }
                    it("includes the expected value") {
                        if let value = observation.valueQuantity{
                            expect(value.value) == 80
                            expect(value.code) == "kg"
                            expect(value.unit) == "kg"
                            expect(value.system?.absoluteString) == "http://unitsofmeasure.org"
                        } else {
                            fail()
                        }
                    }
                    
                    context("when calling the generic resource method") {
                        let observation: Observation = try! observationFactory!.resource(from: sample)
                        
                        itBehavesLike("observation resource") { ["observation" : observation,
                                                                 "codings" : [expectedCoding1, expectedCoding2, expectedCoding3],
                                                                 "effectiveDateTime" : expectedDate,
                                                                 "identifers" : [expectedIdentifier]]
                        }
                        it("includes the expected value") {
                            if let value = observation.valueQuantity{
                                expect(value.value) == 80
                                expect(value.code) == "kg"
                                expect(value.unit) == "kg"
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

