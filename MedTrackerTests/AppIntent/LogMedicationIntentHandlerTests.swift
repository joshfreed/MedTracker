import XCTest
import Intents
@testable import MedTracker
@testable import MedicationApp

class LogMedicationIntentHandlerTests: XCTestCase {
    var sut: LogMedicationIntentHandler!
    let mockRecordAdministration = MockRecordAdministrationUseCase()
    let mockGetTrackedMedications = MockGetTrackedMedicationsUseCase()

    override func setUpWithError() throws {
        sut = LogMedicationIntentHandler(
            recordAdministration: mockRecordAdministration,
            getTrackedMedications: mockGetTrackedMedications
        )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: handle

    func testRecordsTheAdministration() async throws {
        // Given
        let intent = LogMedicationIntent()
        intent.medication = "Advil"
        let expectedCommand = RecordAdministrationByNameCommand(medicationName: "Advil")

        // When
        let response = await sut.handle(intent: intent)

        // Then
        mockRecordAdministration.verify_recordAdministrationByName_wasHandled(with: expectedCommand)
        XCTAssertEqual(.success, response.code)
        XCTAssertEqual("Advil", response.medicationName)
        XCTAssertNil(response.userActivity)
    }

    func test_intent_medication_name_is_nil() async {
        // Given
        let intent = LogMedicationIntent()

        // When
        let response = await sut.handle(intent: intent)

        // Then
        mockRecordAdministration.verify_recordAdministrationByName_wasNotCalled()
        XCTAssertEqual(.failure, response.code)
        XCTAssertNil(response.medicationName)
        XCTAssertNil(response.userActivity)
    }

    func test_unexpected_use_case_error_returns_failure() async {
        // Given
        let intent = LogMedicationIntent()
        intent.medication = "Advil"
        let expectedCommand = RecordAdministrationByNameCommand(medicationName: "Advil")
        mockRecordAdministration.configure_recordAdministrationByName_willThrow(RecordAdministrationError.invalidMedicationId)

        // When
        let response = await sut.handle(intent: intent)

        // Then
        mockRecordAdministration.verify_recordAdministrationByName_wasHandled(with: expectedCommand)
        XCTAssertEqual(.failure, response.code)
        XCTAssertEqual("Advil", response.medicationName)
        XCTAssertNil(response.userActivity)
    }

    func test_returns_failure_if_no_medication_is_found_matching_the_name() async {
        // Given
        let intent = LogMedicationIntent()
        intent.medication = "Advil"
        let expectedCommand = RecordAdministrationByNameCommand(medicationName: "Advil")
        mockRecordAdministration.configure_recordAdministrationByName_willThrow(RecordAdministrationError.medicationNotFound)

        // When
        let response = await sut.handle(intent: intent)

        // Then
        mockRecordAdministration.verify_recordAdministrationByName_wasHandled(with: expectedCommand)
        XCTAssertEqual(.notFound, response.code)
        XCTAssertEqual("Advil", response.medicationName)
        XCTAssertNil(response.userActivity)
    }

    func test_returns_alreadyLogged_if_the_medication_was_already_logged_today() async {
        // Given
        let intent = LogMedicationIntent()
        intent.medication = "Advil"
        let expectedCommand = RecordAdministrationByNameCommand(medicationName: "Advil")
        mockRecordAdministration.configure_recordAdministrationByName_willThrow(RecordAdministrationError.administrationAlreadyRecorded)

        // When
        let response = await sut.handle(intent: intent)

        // Then
        mockRecordAdministration.verify_recordAdministrationByName_wasHandled(with: expectedCommand)
        XCTAssertEqual(.alreadyLogged, response.code)
        XCTAssertEqual("Advil", response.medicationName)
        XCTAssertNil(response.userActivity)
    }

    // MARK: resolveMedication

    func test_resolveMedication_with_string_value_returns_success() async {
        // Given
        let intent = LogMedicationIntent()
        intent.medication = "Advil"

        // When
        let result = await sut.resolveMedication(for: intent)

        // Then
        let resolutionResultCode = result.value(forKeyPath: "resolutionResultCode") as? Int64
        let resolvedValue = result.value(forKeyPath: "resolvedValue") as? String
        XCTAssertEqual("Advil", resolvedValue)
        XCTAssertEqual(0, resolutionResultCode)
    }

    func test_resolveMedication_with_nil_value_returns_needsValue() async {
        // Given
        let intent = LogMedicationIntent()
        intent.medication = nil

        // When
        let result = await sut.resolveMedication(for: intent)

        // Then
        let resolutionResultCode = result.value(forKeyPath: "resolutionResultCode") as? Int64
        let resolvedValue = result.value(forKeyPath: "resolvedValue") as? String
        XCTAssertNil(resolvedValue)
        XCTAssertEqual(4, resolutionResultCode)
    }

    func test_resolveMedication_with_empty_string_value_returns_needsValue() async {
        // Given
        let intent = LogMedicationIntent()
        intent.medication = ""

        // When
        let result = await sut.resolveMedication(for: intent)

        // Then
        let resolutionResultCode = result.value(forKeyPath: "resolutionResultCode") as? Int64
        let resolvedValue = result.value(forKeyPath: "resolvedValue") as? String
        XCTAssertNil(resolvedValue)
        XCTAssertEqual(4, resolutionResultCode)
    }

    func test_resolveMedication_with_no_string_and_user_has_exactly_1_medication_tracked_returns_that_medication() async {
        // Given
        let intent = LogMedicationIntent()
        intent.medication = nil
        mockGetTrackedMedications.configure_toReturn(response: .init(date: Date.current, medications: [.init(id: "AAA", name: "Tylenol")]))

        // When
        let result = await sut.resolveMedication(for: intent)

        // Then
        let resolutionResultCode = result.value(forKeyPath: "resolutionResultCode") as? Int64
        let resolvedValue = result.value(forKeyPath: "resolvedValue") as? String
        XCTAssertEqual("Tylenol", resolvedValue)
        XCTAssertEqual(0, resolutionResultCode)
    }

    func test_resolveMedication_with_no_string_and_user_has_exactly_multiple_medications_tracked_returns_needsValue() async {
        // Given
        let intent = LogMedicationIntent()
        intent.medication = nil
        mockGetTrackedMedications.configure_toReturn(response: .init(date: Date.current, medications: [
            .init(id: "AAA", name: "Tylenol"),
            .init(id: "BBB", name: "Advil")
        ]))

        // When
        let result = await sut.resolveMedication(for: intent)

        // Then
        let resolutionResultCode = result.value(forKeyPath: "resolutionResultCode") as? Int64
        let resolvedValue = result.value(forKeyPath: "resolvedValue") as? String
        XCTAssertNil(resolvedValue)
        XCTAssertEqual(4, resolutionResultCode)
    }
}
