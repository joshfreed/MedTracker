import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let main = Logger(subsystem: subsystem, category: "main")
    static let dailySchedule = Logger(subsystem: subsystem, category: "dailySchedule")
    static let trackMedication = Logger(subsystem: subsystem, category: "trackMedication")

    func error(_ error: Error) {
        self.error("\(String(describing: error))")
    }
}
