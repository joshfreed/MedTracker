import SwiftUI
import OSLog
import Combine
import Dip
import JFLib_Services

@main
struct MedTrackerApp: App {
    private let env: Environment
    private let coreDataSaveListener = CoreDataSaveListener()

    init() {
        let storeUrl = URL.storeURL(for: "group.medtracker.core.data", databaseName: "MedTracker").absoluteString
        Logger.main.debug("CORE DATA: \(storeUrl, privacy: .public)")

        env = Environment.autodetect

        let serviceContainer = Dip.DependencyContainer()
        bootstrapModules(container: serviceContainer)
        JFServices.initialize(container: serviceContainer)
        bootstrapEnvironment()
    }

    var body: some Scene {
        WindowGroup {
            DailyScheduleView()
        }
    }

    private func bootstrapModules(container: DependencyContainer) {
        MedicationModule().bootstrap(env: env, container: container)
        container.register(.unique) {
            DefaultBackEnd(
                trackMedication: $0,
                getTrackedMedications: $1,
                recordAdministration: $2,
                removeAdministration: $3
            )
        }.implements(MedTrackerBackEnd.self)
        container.register(.unique) { MedTrackerApplication(backEnd: $0) }
    }

    private func bootstrapEnvironment() {
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

extension MedTrackerApp {
    enum Environment {
        case live
        case test
        case preview

        static var autodetect: Environment {
            if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
                return .preview
            } else if ProcessInfo.processInfo.arguments.contains("UI_TESTING") {
                return .test
            } else {
                return .live
            }
        }
    }
}
