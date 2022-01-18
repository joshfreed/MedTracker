import Foundation
import JFLib_DomainEvents

class EmptyDonationService: ShortcutDonationService {
    func donateInteraction<T>(domainEvent: T) where T : DomainEvent {}
}
