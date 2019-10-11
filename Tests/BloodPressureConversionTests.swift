//
//  BloodPressureConversionTests.swift
//  HealthKitToFhir_Tests
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import Quick
import Nimble
import HealthKit
import FHIR

class BloodPresureConversionSpec : QuickSpec {
    override func spec() {
        describe("a blood pressure sample conversion") {
            context("the output FHIR Observation") {
                
                let expectedDate = Date.init(timeIntervalSince1970: 0)
                let diastolicSample = HKQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!, quantity: HKQuantity(unit: HKUnit(from: "mmHg"), doubleValue: 80), start: expectedDate, end: expectedDate)
                let systolicSample = HKQuantitySample.init(type: HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!, quantity: HKQuantity(unit: HKUnit(from: "mmHg"), doubleValue: 120), start: expectedDate, end: expectedDate)
                let sample = HKCorrelation.init(type: HKCorrelationType.correlationType(forIdentifier: .bloodPressure)!, start: expectedDate, end: expectedDate, objects: [diastolicSample, systolicSample], metadata: [HKMetadataKeyTimeZone : TimeZone.knownTimeZoneIdentifiers.last!])
                
                let expectedCoding = Coding()
                expectedCoding.code = FHIRString("85354-9")
                expectedCoding.display = FHIRString("Blood pressure panel")
                expectedCoding.system = FHIRURL("http://loinc.org")
                
                let expectedIdentifier = Identifier()
                expectedIdentifier.system = FHIRURL("com.apple.health")
                expectedIdentifier.value = FHIRString(sample.uuid.uuidString)
                
                context("when using the default config") {
                    let observationFactory = try! ObservationFactory()
                    let observation = try! observationFactory.observation(from: sample)
                    
                    itBehavesLike("observation resource") { ["observation" : observation,
                                                             "codings" : [expectedCoding],
                                                             "effectiveDateTime" : expectedDate,
                                                             "identifers" : [expectedIdentifier]]
                    }
                    
                    it("includes the expected values") {
                        if let component = observation.component,
                            let diastolic = component.first(where: { $0.code?.coding?.first?.display?.string == "Diastolic blood pressure" }),
                            let systolic = component.first(where: { $0.code?.coding?.first?.display?.string == "Systolic blood pressure" }) {
                            expect(component.count) == 2
                            let diastolicValue = diastolic.valueQuantity
                            expect(diastolicValue?.value) == 80
                            expect(diastolicValue?.code) == "mmHg"
                            expect(diastolicValue?.unit) == "mmHg"
                            expect(diastolicValue?.system?.absoluteString) == "http://unitsofmeasure.org"
                            let systolicValue = systolic.valueQuantity
                            expect(systolicValue?.value) == 120
                            expect(systolicValue?.code) == "mmHg"
                            expect(systolicValue?.unit) == "mmHg"
                            expect(systolicValue?.system?.absoluteString) == "http://unitsofmeasure.org"
                        } else {
                            fail()
                        }
                    }
                    
                    context("when calling the generic resource method") {
                        let observation: Observation = try! observationFactory.resource(from: sample)
                        
                        itBehavesLike("observation resource") { ["observation" : observation,
                                                                 "codings" : [expectedCoding],
                                                                 "effectiveDateTime" : expectedDate,
                                                                 "identifers" : [expectedIdentifier]]
                        }
                        
                        it("includes the expected values") {
                            if let component = observation.component,
                                let diastolic = component.first(where: { $0.code?.coding?.first?.display?.string == "Diastolic blood pressure" }),
                                let systolic = component.first(where: { $0.code?.coding?.first?.display?.string == "Systolic blood pressure" }) {
                                expect(component.count) == 2
                                let diastolicValue = diastolic.valueQuantity
                                expect(diastolicValue?.value) == 80
                                expect(diastolicValue?.code) == "mmHg"
                                expect(diastolicValue?.unit) == "mmHg"
                                expect(diastolicValue?.system?.absoluteString) == "http://unitsofmeasure.org"
                                let systolicValue = systolic.valueQuantity
                                expect(systolicValue?.value) == 120
                                expect(systolicValue?.code) == "mmHg"
                                expect(systolicValue?.unit) == "mmHg"
                                expect(systolicValue?.system?.absoluteString) == "http://unitsofmeasure.org"
                            } else {
                                fail()
                            }
                        }
                        
                        context("The incorrect type is used") {
                            it("throws an error") {
                                expect {
                                    let observation: Device? = try observationFactory.resource(from: sample)
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

