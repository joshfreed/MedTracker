import XCTest

class DailySchedulePage {
    let app: XCUIApplication

    init(app: XCUIApplication, date: Date) throws {
        self.app = app
        guard waitForExistence(date: date) else { throw PageErrors.wrongPage }
    }

    private func waitForExistence(date: Date) -> Bool {
        let title = title(with: date)
        return app.navigationBars[title].waitForExistence(timeout: .default)
    }

    private func title(with date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "MMMM d"
        return df.string(from: date)
    }

    func trackNewMedication() throws -> NewMedicationPage {
        app.buttons["trackMedication"].tap()
        return try NewMedicationPage(app: app)
    }

    func getMedication(named name: String) throws -> MedicationEntry {
        return try MedicationEntry(app: app, medicationName: name)
    }
}
