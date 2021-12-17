import Foundation
import Combine
import CoreData
import OSLog
import JFLib_Services
import MedicationApp

class CoreDataSaveListener {
    private var cancellable: AnyCancellable?

    func listenForCoreDataUpdates() {
        cancellable = UserDefaultsCoreDataNotifier.shared
            .coreDataDidChange()
            .sink {
                Logger.main.debug("Core data did change!")

                guard let context: NSManagedObjectContext = try? JFServices.resolve() else {
                    Logger.main.error("Could not resolve NSManagedObjectContext from services")
                    return
                }

                // `refreshAllObjects` only refreshes objects from which the cache is invalid. With a staleness intervall of -1 the cache never invalidates.
                // We set the `stalenessInterval` to 0 to make sure that changes in the app extension get processed correctly.
                context.stalenessInterval = 0
                context.refreshAllObjects()
                context.stalenessInterval = -1

                guard let medService: MedicationService = try? JFServices.resolve() else {
                    Logger.main.error("Could not resolve MedicationService from services")
                    return
                }

                medService.refreshContinuousQueries()
            }
    }
}
