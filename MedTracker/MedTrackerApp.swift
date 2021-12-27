import SwiftUI
import OSLog
import Combine
import Dip
import JFLib_Services
import MedicationApp
import CoreData

@main
struct MedTrackerApp: App {
    private let env: Environment
    private let coreDataSaveListener = CoreDataSaveListener()

    init() {
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

final class MedicationModule {
    func bootstrap(env: MedTrackerApp.Environment, container: DependencyContainer) {
        container
            .register(.singleton) {
                MedicationService(
                    medications: $0,
                    administrations: $1,
                    shortcutDonation: $2,
                    widgetService: $3
                )
            }
            .implements(
                GetTrackedMedicationsContinuousQuery.self,
                RecordAdministrationUseCase.self,
                RemoveAdministrationUseCase.self,
                TrackMedicationUseCase.self
            )

        switch env {
        case .live:
            container.register { IntentDonationService() }.implements(ShortcutDonationService.self)
            container.register { MedTrackerWidgetCenter() }.implements(WidgetService.self)
            container.register(.singleton) { PersistenceController.shared.container.viewContext }
            container.register { CoreDataMedications(context: $0) }.implements(MedicationRepository.self)
            container.register { CoreDataAdministrations(context: $0) }.implements(AdministrationRepository.self)
        case .test:
            container.register { EmptyDonationService() }.implements(ShortcutDonationService.self)
            container.register { EmptyWidgetService() }.implements(WidgetService.self)
            container.register(.singleton) { PersistenceController.testing.container.viewContext }
            container.register { CoreDataMedications(context: $0) }.implements(MedicationRepository.self)
            container.register { CoreDataAdministrations(context: $0) }.implements(AdministrationRepository.self)
        case .preview:
            container.register { EmptyDonationService() }.implements(ShortcutDonationService.self)
            container.register { EmptyWidgetService() }.implements(WidgetService.self)
            container.register { MemoryMedications() }.implements(MedicationRepository.self)
            container.register { MemoryAdministrations() }.implements(AdministrationRepository.self)
        }
    }
}
