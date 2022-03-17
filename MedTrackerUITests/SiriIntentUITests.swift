//
//  SiriIntentUITests.swift
//  MedTrackerUITests
//
//  Created by Josh Freed on 1/15/22.
//

import XCTest

class SiriIntentUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func skip_testExample() throws {
        let today = Date()
        let medications: [[AnyHashable: Any]] = [
            [
                "id": ["uuid": UUID().uuidString],
                "name": "Crazy Pills",
                "administrationTime": 9
            ]
        ]
        let app = launch(medications: medications)

        sleep(3)
        
        XCUIDevice.shared.press(.home)

        sleep(3)

        let siri = XCUIDevice.shared.siriService

        siri.activate(voiceRecognitionText: "Log UI Test")

        let predicate = NSPredicate {(_, _) -> Bool in
            sleep(5)
            return true
        }

        let siriResponse = expectation(for: predicate, evaluatedWith: siri, handler: nil)

        self.wait(for: [siriResponse], timeout: 10)

        app.activate()

        let home = try DailySchedulePage(app: app, date: today)
        let med = try home.getMedication(named: "Crazy Pills")
        XCTAssertTrue(med.wasAdministered)
    }
}
