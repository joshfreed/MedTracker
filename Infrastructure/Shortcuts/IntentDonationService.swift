import Foundation
import Intents
import JFLib_DomainEvents
import MedicationApp

class IntentDonationService: ShortcutDonationService {
    func donateInteraction<T>(domainEvent: T) where T : DomainEvent {
        if let domainEvent = domainEvent as? AdministrationRecorded {
            donateAdministrationRecorded(domainEvent)
        }
    }

    private func donateAdministrationRecorded(_ domainEvent: AdministrationRecorded) {
        let intent = LogMedicationIntent()
        intent.medication = domainEvent.medicationName
        intent.suggestedInvocationPhrase = "Log \(domainEvent.medicationName)"

        let interaction = INInteraction(intent: intent, response: nil)
        interaction.identifier = domainEvent.id.description
        interaction.donate()
    }
}
