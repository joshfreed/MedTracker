import Intents
import MedicationApp
import CoreDataKit

class IntentHandler: INExtension {
    private lazy var medicationService: MedicationService = {
        let context = PersistenceController.shared.container.viewContext

        return MedicationService(
            medications: CoreDataMedications(context: context),
            administrations: CoreDataAdministrations(context: context),
            shortcutDonation: EmptyDonationService(),
            widgetService: MedTrackerWidgetCenter()
        )
    }()

    override func handler(for intent: INIntent) -> Any? {
        if intent is LogMedicationIntent {
            return LogMedicationIntentHandler(
                recordAdministration: medicationService,
                getTrackedMedications: medicationService
            )
        }

        return nil
    }
}
