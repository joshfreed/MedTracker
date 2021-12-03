import SwiftUI
import JFLib_Services
import MedicationApp

@main
struct MedTrackerApp: App {
    init() {
        let serviceContainer = DipContainer()
        MedicationModule().bootstrap(env: .live, container: serviceContainer)
        JFServices.initialize(container: serviceContainer)
    }

    var body: some Scene {
        WindowGroup {
            DailyScheduleView()
        }
    }
}

enum AppEnvironment {
    case live
    case test
    case preview
}

protocol JFAppModule {
    func bootstrap(env: AppEnvironment, container: JFServiceContainer)
}

final class MedicationModule: JFAppModule {
    func bootstrap(env: AppEnvironment, container: JFServiceContainer) {
        container.register(GetTrackedMedicationsUseCase.self) { MedicationService(medications: $0, administrations: $1) }
        container.register(RecordAdministrationUseCase.self) { MedicationService(medications: $0, administrations: $1) }
        container.register(TrackMedicationUseCase.self) { MedicationService(medications: $0, administrations: $1) }
        container.register(MedicationRepository.self) { MemoryMedications() }
        container.register(AdministrationRepository.self) { MemoryAdministrations() }
    }
}
