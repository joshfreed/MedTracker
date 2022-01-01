import Intents
import OSLog
import MedicationApp
import CoreData
import CoreDataKit

class IntentHandler: INExtension {
    private let logger = Logger.intent

    private lazy var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    private lazy var medicationService = MedicationService(
            medications: CoreDataMedications(context: context),
            administrations: CoreDataAdministrations(context: context),
            shortcutDonation: EmptyDonationService(),
            widgetService: MedTrackerWidgetCenter()
        )

    private lazy var coreDataSavePublisher = CoreDataSavePublisher(
        context: context,
        notifier: UserDefaultsCoreDataNotifier.shared,
        logger: logger
    )

    override init() {
        super.init()
        logger.debug("IntentHandler::init")
        coreDataSavePublisher.publishWhenCoreDataSaves()
    }

    deinit {
        logger.debug("IntentHandler::deinit")
        coreDataSavePublisher.stopPublishing()
    }

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
