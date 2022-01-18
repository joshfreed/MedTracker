import Foundation
import JFLib_DomainEvents

public protocol ShortcutDonationService {
    func donateInteraction<T: DomainEvent>(domainEvent: T)
}
