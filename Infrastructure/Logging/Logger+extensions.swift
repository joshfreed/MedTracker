import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let main = Logger(subsystem: subsystem, category: "main")
    static let dailySchedule = Logger(subsystem: subsystem, category: "dailySchedule")
    static let trackMedication = Logger(subsystem: subsystem, category: "trackMedication")
    static let intent = Logger(subsystem: subsystem, category: "intent")
    static let widget = Logger(subsystem: subsystem, category: "widget")

    func error(_ error: Error) {
        self.error("\(String(describing: error))")
    }
}
