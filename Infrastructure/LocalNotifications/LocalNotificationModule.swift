import Foundation
import Combine
import UserNotifications
import Dip
import JFLib_Services
import MedTrackerBackEnd
import Common

class LocalNotificationModule {
    private var cancellables = Set<AnyCancellable>()
    
    func registerServices(env: XcodeEnvironment, container: DependencyContainer) {
        switch env {
        case .live:
            container.register(.unique) { LocalNotificationService() }.implements(ReminderService.self)
        case .test:
            container.register(.unique) { EmptyReminderService() }.implements(ReminderService.self)
        case .preview:
            container.register(.unique) { EmptyReminderService() }.implements(ReminderService.self)
        }
    }

    func bootstrap(env: XcodeEnvironment) {
        guard env == .live else { return }

        configureNotifications()

        let domainEvents: MedTrackerBackEndEvents = try! JFServices.resolve()

        domainEvents
            .newMedicationTracked
            .sink { event in
                Task {
                    let reminderService: ReminderService = try! JFServices.resolve()
                    try await reminderService.scheduleDailyReminder(for: event.id, medicationName: event.name, at: event.administrationTime)
                }
            }
            .store(in: &cancellables)

        // TODO
//        private let localNotificationHandler = LocalNotificationHandler()
    }

    private func configureNotifications() {
        let takeAction = UNNotificationAction(identifier: "TAKE_ACTION", title: "Take", options: [])
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION", title: "Snooze", options: [])
        let medicationReminderCategory = UNNotificationCategory(
            identifier: "MEDICATION_REMINDER",
            actions: [takeAction, snoozeAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction
        )

        let yesAction = UNNotificationAction(identifier: "YES_ACTION", title: "Yes", options: [])
        let noAction = UNNotificationAction(identifier: "NO_ACTION", title: "Not Yet", options: [])
        let medCheckInCategory = UNNotificationCategory(
            identifier: "MEDICATION_CHECK_IN",
            actions: [yesAction, noAction],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction
        )

        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([medicationReminderCategory, medCheckInCategory])
    }
}
