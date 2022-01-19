import Foundation
import OSLog
import MedicationContext
import CoreData
import CoreDataKit

class AppIntentsServices {
    let logger = Logger.intent

    private lazy var context: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    private(set) lazy var coreDataSavePublisher = CoreDataSavePublisher(
        context: context,
        notifier: UserDefaultsCoreDataNotifier.shared,
        logger: logger
    )
}
