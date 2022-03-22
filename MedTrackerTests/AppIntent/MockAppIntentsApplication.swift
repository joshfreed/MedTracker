//
//  MockAppIntentsApplication.swift
//  MedTrackerTests
//
//  Created by Josh Freed on 1/15/22.
//

import XCTest
@testable import MedTracker
import MTBackEndCore

class MockAppIntentsApplication: AppIntentsApplication {
    // MARK: Get Tracked Medications

    var response: GetTrackedMedicationsResponse = GetTrackedMedicationsResponse(date: Date.current, medications: [])

    func configure_toReturn(response: GetTrackedMedicationsResponse) {
        self.response = response
    }

    func getTrackedMedications(date: Date) async throws -> GetTrackedMedicationsResponse {
        response
    }

    // MARK: Record Administration by Name

    var recordByNameWasCalled = false
    var recordByNameName: String?
    var recordByNameError: RecordAdministrationError?

    func configure_recordAdministrationByName_willThrow(_ error: RecordAdministrationError) {
        recordByNameError = error
    }

    func recordAdministration(medicationName: String) async throws {
        recordByNameWasCalled = true
        recordByNameName = medicationName
        if let recordByNameError = recordByNameError {
            throw recordByNameError
        }
    }

    func verify_recordAdministrationByName_wasHandled(with expected: String, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(recordByNameWasCalled, file: file, line: line)
        XCTAssertEqual(expected, recordByNameName, file: file, line: line)
    }

    func verify_recordAdministrationByName_wasNotCalled(file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertFalse(recordByNameWasCalled, file: file, line: line)
    }
}
