import XCTest

class MedTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testPrimaryFlow_add_medication_and_mark_administered() throws {
        let app = launch()

        var home = try DailySchedulePage(app: app, date: Date())
        let newMedication = try home.trackNewMedication()
        newMedication.typeMedicationName("My New Med")
        home = try newMedication.submit()
        let med = try home.getMedication(named: "My New Med")
        XCTAssertFalse(med.wasAdministered)
        try med.tap()
        XCTAssertTrue(med.wasAdministered)
    }

    func test_record_administration_for_an_existing_medication() throws {
        let today = Date()
        let medications: [[AnyHashable: Any]] = [
            [
                "id": ["uuid": UUID().uuidString],
                "name": "Crazy Pills",
                "administrationTime": 9
            ]
        ]
        let app = launch(medications: medications)

        let home = try DailySchedulePage(app: app, date: today)
        let med = try home.getMedication(named: "Crazy Pills")
        XCTAssertFalse(med.wasAdministered)
        try med.tap()
        XCTAssertTrue(med.wasAdministered)
    }

    func test_remove_the_recorded_administration_of_a_medication() throws {
        // Given
        let today = Date()
        let medicationId = ["uuid": UUID().uuidString]
        let medications: [[AnyHashable: Any]] = [
            [
                "id": medicationId,
                "name": "Crazy Pills",
                "administrationTime": 9
            ]
        ]
        let administrations: [[AnyHashable: Any]] = [
            [
                "id": ["uuid": UUID().uuidString],
                "medicationId": medicationId,
                "administrationDate": today.timeIntervalSinceReferenceDate
            ]
        ]
        let app = launch(medications: medications, administrations: administrations)

        // When
        let home = try DailySchedulePage(app: app, date: today)
        let med = try home.getMedication(named: "Crazy Pills")
        XCTAssertTrue(med.wasAdministered)
        try med.tap()
        XCTAssertFalse(med.wasAdministered)
    }

    // MARK: - Helpers

    private func launch(
        medications: [[AnyHashable: Any]]? = nil,
        administrations: [[AnyHashable: Any]]? = nil
    ) -> XCUIApplication {
        let app = XCUIApplication()

        app.launchArguments.append("UI_TESTING")

        if let medications = medications {
            app.launchEnvironment["medications"] = medications.toJsonString()
        }
        if let administrations = administrations {
            app.launchEnvironment["administrations"] = administrations.toJsonString()
        }

        app.launch()

        return app
    }
}
