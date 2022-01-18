import SwiftUI
import OSLog
import Dip
import JFLib_Services
import Common
import DefaultBackEnd

@main
struct MedTrackerApp: App {
    private let env: XcodeEnvironment
    private let backEndModule = BackEndModule()
    private let widgetCenterModule = WidgetCenterModule()
    private let shortcutsModule = ShortcutsModule()
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
        backEndModule.registerServices(env: env, container: container)
        widgetCenterModule.registerServices(env: env, container: container)
        shortcutsModule.registerServices(env: env, container: container)

        container.register(.unique) { ApplicationFacade(backEnd: $0) }.implements(MedTrackerApplication.self)
    }

    private func bootstrapEnvironment() {
        backEndModule.bootstrap(env: env)
        widgetCenterModule.bootstrap(env: env)
        shortcutsModule.bootstrap(env: env)
        
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
