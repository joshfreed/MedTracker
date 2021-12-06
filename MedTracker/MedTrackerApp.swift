import SwiftUI
import OSLog
import Dip
import JFLib_Services
import MedicationApp

@main
struct MedTrackerApp: App {
    let env: Environment

    init() {
        env = Environment.autodetect

        let serviceContainer = Dip.DependencyContainer()
        bootstrapModules(container: serviceContainer)
        JFServices.initialize(container: serviceContainer)
        if env == .test {
            prepareUITesting()
        }
    }

    var body: some Scene {
        WindowGroup {
            DailyScheduleView()
        }
    }

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

    private func bootstrapModules(container: DependencyContainer) {
        MedicationModule().bootstrap(env: env, container: container)
    }

    private func prepareUITesting() {
        Task {
            try! await UITestHelper().loadMedications()
            try! await UITestHelper().loadAdministrations()
        }
    }
}

final class MedicationModule {
    func bootstrap(env: MedTrackerApp.Environment, container: DependencyContainer) {
        container
            .register(.singleton) { MedicationService(medications: $0, administrations: $1, shortcutDonation: $2) }
            .implements(
                GetTrackedMedicationsContinuousQuery.self,
                RecordAdministrationUseCase.self,
                RemoveAdministrationUseCase.self,
                TrackMedicationUseCase.self
            )

        switch env {
        case .live:
            container.register { IntentDonationService() }.implements(ShortcutDonationService.self)
            container.register(.singleton) { PersistenceController.shared.container.viewContext }
            container.register { CoreDataMedications(context: $0) }.implements(MedicationRepository.self)
            container.register { CoreDataAdministrations(context: $0) }.implements(AdministrationRepository.self)
        case .test:
            container.register { EmptyDonationService() }.implements(ShortcutDonationService.self)
            container.register(.singleton) { PersistenceController.testing.container.viewContext }
            container.register { CoreDataMedications(context: $0) }.implements(MedicationRepository.self)
            container.register { CoreDataAdministrations(context: $0) }.implements(AdministrationRepository.self)
        case .preview:
            container.register { EmptyDonationService() }.implements(ShortcutDonationService.self)
            container.register { MemoryMedications() }.implements(MedicationRepository.self)
            container.register { MemoryAdministrations() }.implements(AdministrationRepository.self)
        }
    }
}
