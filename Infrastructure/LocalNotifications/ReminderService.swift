import Foundation

public protocol ReminderService {
    func scheduleDailyReminder(for medicationId: String, medicationName: String, at hour: Int) async throws
}

class EmptyReminderService: ReminderService {
    func scheduleDailyReminder(for medicationId: String, medicationName: String, at hour: Int) async throws {}
}
