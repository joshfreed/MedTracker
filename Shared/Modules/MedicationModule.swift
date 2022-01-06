import Foundation
import Dip
import JFLib_Services
import MedicationApp
import CoreDataKit

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
