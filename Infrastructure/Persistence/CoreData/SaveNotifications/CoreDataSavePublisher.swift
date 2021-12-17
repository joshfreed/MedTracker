import Foundation
import CoreData
import Combine
import OSLog

class CoreDataSavePublisher {
    private var context: NSManagedObjectContext
    private var cancellable: AnyCancellable?

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func publishWhenCoreDataSaves() {
        cancellable = NotificationCenter.default
            .publisher(for: NSManagedObjectContext.didSaveObjectsNotification, object: context)
            .sink { _ in
                Logger.main.debug("Received MOC didSaveObjectsNotification")
                UserDefaultsCoreDataNotifier.shared.postCoreDataDidChange()
            }
    }
}
