import SwiftUI
import Dip
import JFLib_Services
import MedicationApp

@main
struct MedTrackerApp: App {
    let env: Environment

    init() {
        env = .live

        let serviceContainer = Dip.DependencyContainer()
        bootstrapModules(container: serviceContainer)
        JFServices.initialize(container: serviceContainer)
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
    }

    private func bootstrapModules(container: DependencyContainer) {
        MedicationModule().bootstrap(env: env, container: container)
    }
}

final class MedicationModule {
    func bootstrap(env: MedTrackerApp.Environment, container: DependencyContainer) {
        container
            .register(.singleton) { MedicationService(medications: $0, administrations: $1) }
            .implements(
                GetTrackedMedicationsContinuousQuery.self,
                RecordAdministrationUseCase.self,
                TrackMedicationUseCase.self
            )

        container.register { MemoryMedications() }.implements(MedicationRepository.self)
        container.register { MemoryAdministrations() }.implements(AdministrationRepository.self)
    }
}
