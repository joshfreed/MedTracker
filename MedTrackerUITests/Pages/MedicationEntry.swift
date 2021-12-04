import XCTest

class MedicationEntry {
    var wasAdministered: Bool {
        (el.images["administrationState"].value as! String) == "Administered"
    }

    private let app: XCUIApplication
    private let medicationName: String

    private var el: XCUIElement {
        app.otherElements["Medication Entry: \(medicationName)"]
    }

    init(app: XCUIApplication, medicationName: String) throws {
        self.app = app
        self.medicationName = medicationName

        guard el.waitForExistence(timeout: .default) else { throw PageErrors.illegalState }
    }

    func tap() throws {
        el.tap()
    }
}
