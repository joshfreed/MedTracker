import Intents
import OSLog
import MedicationApp

class LogMedicationIntentHandler: NSObject, LogMedicationIntentHandling {
    private let recordAdministration: RecordAdministrationUseCase
    private let logger = Logger.main

    init(recordAdministration: RecordAdministrationUseCase) {
        self.recordAdministration = recordAdministration
    }

    func handle(intent: LogMedicationIntent) async -> LogMedicationIntentResponse {
        logger.debug("Handling intent")

        guard let medicationName = intent.medication else {
            fatalError("no name?")
        }

        do {
            let command = RecordAdministrationByNameCommand(medicationName: medicationName)
            try await recordAdministration.handle(command)

            let response = LogMedicationIntentResponse(code: .success, userActivity: nil)
            response.medicationName = medicationName
            return response
        } catch {
            logger.error(error)
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
