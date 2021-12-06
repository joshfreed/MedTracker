import Foundation
import Intents
import MedicationApp

class LogMedicationIntentHandler: NSObject, LogMedicationIntentHandling {
    func handle(intent: LogMedicationIntent) async -> LogMedicationIntentResponse {
        print("Handling intent")

        guard let medicationName = intent.medication else {
            fatalError("no name?")
        }

        let context = PersistenceController.shared.container.viewContext

        let medicationService = MedicationService(
            medications: CoreDataMedications(context: context),
            administrations: CoreDataAdministrations(context: context),
            shortcutDonation: EmptyDonationService()
        )

        do {
            print("Log Medication \(medicationName)")
            let command = RecordAdministrationByNameCommand(medicationName: medicationName)
            try await medicationService.handle(command)
            print("Medication logged")
            let response = LogMedicationIntentResponse(code: .success, userActivity: nil)
            response.medicationName = medicationName
            return response
        } catch {
            print("Failed to log: \(error)")
            return .init(code: .failure, userActivity: nil)
        }
    }

    func resolveMedication(for intent: LogMedicationIntent) async -> INStringResolutionResult {
        if let medication = intent.medication, !medication.isEmpty {
            return .success(with: medication)
        } else {
            return .needsValue()
        }
    }
}
