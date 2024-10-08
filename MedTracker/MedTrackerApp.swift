import SwiftUI
import OSLog
import Dip
import JFLib_Services
import MTCommon
import MTBackEndCore
import MTDefaultBackEnd
import MTWidgetCenter
import MTLocalNotifications

typealias MedTrackerApplication = MedTrackerBackEnd

@main
struct MedTrackerApp: App {
    private let env: XcodeEnvironment
    private let modules: [MedTrackerModule] = [
        BackEndModule(),
        WidgetCenterModule(),
        ShortcutsModule(),
        LocalNotificationModule(),
    ]
    private let coreDataSaveListener = CoreDataSaveListener()

    init() {
        let storeUrl = URL.storeURL(for: "group.medtracker.core.data", databaseName: "MedTracker").absoluteString
        Logger.main.debug("CORE DATA: \(storeUrl, privacy: .public)")

        env = XcodeEnvironment.autodetect()

        let serviceContainer = DipContainer()
        registerServices(container: serviceContainer.container)
        JFServices.initialize(container: serviceContainer)
        bootstrapEnvironment()
    }

    var body: some Scene {
        WindowGroup {
            DailyScheduleView()
        }
    }

    private func registerServices(container: DependencyContainer) {
        modules.forEach { $0.registerServices(env: env, container: container) }
    }

    private func bootstrapEnvironment() {
        modules.forEach { $0.bootstrap(env: env) }
        
        switch env {
        case .live:
            coreDataSaveListener.listenForCoreDataUpdates()
        case .preview: break
        case .test:
            prepareUITesting()
        }
    }

    private func prepareUITesting() {
        Task {
            try! await UITestHelper().loadMedications()
            try! await UITestHelper().loadAdministrations()
        }
    }
}
