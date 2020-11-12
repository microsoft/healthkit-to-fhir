//
//  ObservationConversionTestConfiguration.swift
//  HealthKitToFhir_Tests
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.

import Foundation
import FHIR
import Quick
import Nimble

class ObservationConversionTestConfiguration : QuickConfiguration {    
    override class func configure(_ configuration: Configuration) {
        sharedExamples("observation resource") { (sharedExampleContext: @escaping SharedExampleContext) in
            if let observation = sharedExampleContext()["observation"] as? Observation {
                it("includes the expected codes") {
                    if let codings = observation.code?.coding,
                        let expectedCodings = sharedExampleContext()["codings"] as? [Coding] {
                        for coding in expectedCodings {
                            expect(codings.contains(where: { (actual) -> Bool in
                                return coding.code == actual.code && coding.display == actual.display && coding.system?.absoluteString == actual.system?.absoluteString
                            })).to(beTrue())
                        }
                    } else {
                        fail("A precondition for testing observation code has failed")
                    }
                }
                it("has the expected time representation") {
                    if let dateTime = observation.effectiveDateTime,
                        let expectedDataTime = sharedExampleContext()["effectiveDateTime"] as? Date {
                        expect(dateTime.nsDate) == expectedDataTime
                        return
                    }
                    
                    if let period = observation.effectivePeriod,
                        let expectedPeriod = sharedExampleContext()["effectivePeriod"] as? Period {
                        expect(period.start) == expectedPeriod.start
                        expect(period.end) == expectedPeriod.end
                        return
                    }
                    
                    fail("A precondition for testing observation effectiveDateTime has failed")
                }
                it("has an identifier with the expected system") {
                    if let identifiers = observation.identifier,
                        let expectedIdentifiers = sharedExampleContext()["identifers"] as? [Identifier]  {
                        for identifer in expectedIdentifiers {
                            expect(identifiers.contains(where: { (actual) -> Bool in
                                return identifer.system?.absoluteString == actual.system?.absoluteString && identifer.value == actual.value
                            })).to(beTrue())
                        }
                    } else {
                        fail("A precondition for testing observation identifier has failed")
                    }
                }
            } else {
                fail("The test object is not a FHIR.Observation type.")
            }
            
        }
    }
}
