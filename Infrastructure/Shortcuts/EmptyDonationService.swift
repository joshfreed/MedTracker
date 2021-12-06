import Foundation
import JFLib_DomainEvents
import MedicationApp

class EmptyDonationService: ShortcutDonationService {
    func donateInteraction<T>(domainEvent: T) where T : DomainEvent {}
}
