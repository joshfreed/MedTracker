import XCTest

class MedicationReminderSchedulingTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        try clearScheduledNotifications()
    }

    override func tearDownWithError() throws {}

    func test_schedules_notifications_after_adding_a_new_medication() throws {
        let app = launch()
        var home = try DailySchedulePage(app: app, date: Date())
        let newMedication = try home.trackNewMedication()
        newMedication.typeMedicationName("My New Med")
        try clearScheduledNotifications()
        home = try newMedication.submit()

        let scheduledNotifications = try fetchScheduleNotifications()
        XCTAssertGreaterThan(scheduledNotifications.count, 0)
    }

    func test_schedules_notifications_after_recording_an_administration() throws {
        let today = Date()
        let medicationId = UUID().uuidString
        let medications: [[AnyHashable: Any]] = [
            [
                "id": ["uuid": medicationId],
                "name": "Crazy Pills",
                "reminder": [
                    "reminderTime": ["hour": 9, "minute": 0]
                ]
            ]
        ]
        let app = launch(medications: medications)
        let home = try DailySchedulePage(app: app, date: today)
        let med = try home.getMedication(named: "Crazy Pills")
        try clearScheduledNotifications()
        try med.tap()

        let scheduledNotifications = try fetchScheduleNotifications(for: medicationId)
        XCTAssertGreaterThan(scheduledNotifications.count, 0)
    }

    func test_schedules_notifications_after_removing_an_administration() throws {
        // Given
        let today = Date()
        let medicationId = UUID().uuidString
        let medications: [[AnyHashable: Any]] = [
            [
                "id": ["uuid": medicationId],
                "name": "Crazy Pills",
                "reminder": [
                    "reminderTime": ["hour": 9, "minute": 0]
                ]
            ]
        ]
        let administrations: [[AnyHashable: Any]] = [
            [
                "id": ["uuid": UUID().uuidString],
                "medicationId": ["uuid": medicationId],
                "administrationDate": today.timeIntervalSinceReferenceDate
            ]
        ]
        let app = launch(medications: medications, administrations: administrations)

        // When
        let home = try DailySchedulePage(app: app, date: today)
        let med = try home.getMedication(named: "Crazy Pills")
        try clearScheduledNotifications()
        try med.tap()

        let scheduledNotifications = try fetchScheduleNotifications(for: medicationId)
        XCTAssertGreaterThan(scheduledNotifications.count, 0)
    }

    func test_schedules_notifications_for_all_medications_on_app_launch() throws {
        let medicationId = UUID().uuidString
        let medications: [[AnyHashable: Any]] = [
            [
                "id": ["uuid": medicationId],
                "name": "Crazy Pills",
                "reminder": [
                    "reminderTime": ["hour": 9, "minute": 0]
                ]
            ]
        ]
        let app = launch(medications: medications)
        let scheduledNotifications = try fetchScheduleNotifications(for: medicationId)
        XCTAssertGreaterThan(scheduledNotifications.count, 0)
    }

    // MARK: - Helpers

    private func clearScheduledNotifications() throws {
        let notificationsUrl = try getNotificationsUrl()
        let empty: [ReminderNotification] = []
        let emptyData = try JSONEncoder().encode(empty)
        try emptyData.write(to: notificationsUrl)
    }

    private func fetchScheduleNotifications() throws -> [ReminderNotification] {
        let notificationsUrl = try getNotificationsUrl()
        let data = try Data(contentsOf: notificationsUrl)
        let notifications = try JSONDecoder().decode([ReminderNotification].self, from: data)
        return notifications
    }

    private func fetchScheduleNotifications(for medicationId: String) throws -> [ReminderNotification] {
        try fetchScheduleNotifications().filter { $0.medicationId == medicationId }
    }

    private func getNotificationsUrl() throws -> URL {
        let environment = ProcessInfo.processInfo.environment

        guard let resourcesDir = environment["SIMULATOR_SHARED_RESOURCES_DIRECTORY"] else {
            throw TestError.sharedResourcesDirectoryNotFoundInEnvironment
        }

        return URL(fileURLWithPath: "\(resourcesDir)/notifications.json")
    }
}

struct ReminderNotification: Codable {
    let id: String
    let medicationId: String
    let body: String
    let triggerDate: Date
}

enum TestError: Error {
    case sharedResourcesDirectoryNotFoundInEnvironment
}
