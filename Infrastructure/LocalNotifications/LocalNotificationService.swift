import Foundation
import UserNotifications

class LocalNotificationService: ReminderService {
    func scheduleDailyReminder(for medicationId: String, medicationName: String, at hour: Int) async throws {
        let content = UNMutableNotificationContent()
        content.body = "Have you taken your \(medicationName) today?"
        content.categoryIdentifier = "MEDICATION_CHECK_IN"
        content.userInfo["medicationId"] = medicationId

        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = 9

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let notificationId = medicationId
        let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)

        let notificationCenter = UNUserNotificationCenter.current()

        try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])

        try await notificationCenter.add(request)
    }
}
