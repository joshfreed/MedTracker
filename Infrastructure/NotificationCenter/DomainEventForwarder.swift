import Foundation
import JFLib_DomainEvents

class DomainEventForwarder: AnyDomainEventHandler {
    func handleEvent(_ event: DomainEvent) {
        let notificationName = Notification.Name(String(describing: type(of: event)))
        let userInfo: [AnyHashable: Any] = ["domainEvent": event]
        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: userInfo)
    }
}
