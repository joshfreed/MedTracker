import Foundation
import MedicationApp
import XCTest

class MockRecordAdministrationUseCase: RecordAdministrationUseCase {

    // MARK: RecordAdministrationCommand

    func handle(_ command: RecordAdministrationCommand) async throws {
    }

    // MARK: RecordAdministrationByNameCommand

    var recordByNameWasCalled = false
    var recordByNameCommand: RecordAdministrationByNameCommand?
    var recordByNameError: RecordAdministrationError?

    func configure_recordAdministrationByName_willThrow(_ error: RecordAdministrationError) {
        recordByNameError = error
    }

    func handle(_ command: RecordAdministrationByNameCommand) async throws {
        recordByNameWasCalled = true
        recordByNameCommand = command
        if let recordByNameError = recordByNameError {
            throw recordByNameError
        }
    }

    func verify_recordAdministrationByName_wasHandled(with expected: RecordAdministrationByNameCommand, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(recordByNameWasCalled, file: file, line: line)
        XCTAssertEqual(expected, recordByNameCommand, file: file, line: line)
    }

    func verify_recordAdministrationByName_wasNotCalled(file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertFalse(recordByNameWasCalled, file: file, line: line)
    }
}
