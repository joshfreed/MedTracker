import XCTest

class NewMedicationPage {
    let app: XCUIApplication

    init(app: XCUIApplication) throws {
        self.app = app
        guard waitForExistence() else { throw PageErrors.wrongPage }
    }

    private func waitForExistence() -> Bool {
        return app.navigationBars["Track a Medication"].waitForExistence(timeout: .default)
    }

    func typeMedicationName(_ name: String) {
        let textField = app.textFields["medicationName"]
        textField.tap()
        textField.typeText(name)
    }

    func submit() throws -> DailySchedulePage {
        app.buttons["submit"].tap()
        return try DailySchedulePage(app: app, date: Date())
    }
}
