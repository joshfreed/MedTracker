import XCTest

extension XCTestCase {
    func launch(
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

    func toString(_ object: [[String: Any]]) -> String {
        let data = try! JSONSerialization.data(withJSONObject: object, options: [])
        return String(data: data, encoding: .utf8)!
    }
}

extension Dictionary {
    func toJsonString() -> String {
        let data = try! JSONSerialization.data(withJSONObject: self, options: [])
        return String(data: data, encoding: .utf8)!
    }
}

extension Array where Element == [AnyHashable: Any] {
    func toJsonString() -> String {
        let data = try! JSONSerialization.data(withJSONObject: self, options: [])
        return String(data: data, encoding: .utf8)!
    }
}

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        self.tap()

        let selectAll = XCUIApplication().menuItems["Select All"]

        //For empty fields there will be no "Select All", so we need to check
        if selectAll.waitForExistence(timeout: 0.5), selectAll.exists {
            selectAll.tap()
            typeText(String(XCUIKeyboardKey.delete.rawValue))
        }

        self.typeText(text)
    }

    func waitForExistence(timeout: Timeout) -> Bool {
        waitForExistence(timeout: timeout.rawValue)
    }
}
