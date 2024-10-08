import Intents
import OSLog
import MTBackEndCore

class LogMedicationIntentHandler: NSObject, LogMedicationIntentHandling {
    private let application: AppIntentsApplication
    private let logger = Logger.intent

    init(application: AppIntentsApplication) {
        self.application = application
    }

    func handle(intent: LogMedicationIntent) async -> LogMedicationIntentResponse {
        logger.info("Handling intent w/ medication: \(String(describing: intent.medication), privacy: .public)")

        guard let medicationName = intent.medication else {
            logger.error("LogMedicationIntent's medication property is nil. I didn't think this was possible.")
            return .init(code: .failure, userActivity: nil)
        }

        do {
            try await logMedication(named: medicationName)

            logger.debug("success")
            let response = LogMedicationIntentResponse(code: .success, userActivity: nil)
            response.medicationName = medicationName
            return response
        } catch RecordAdministrationError.medicationNotFound {
            logger.debug("medicationNotFound")
            let response = LogMedicationIntentResponse(code: .notFound, userActivity: nil)
            response.medicationName = medicationName
            return response
        } catch RecordAdministrationError.administrationAlreadyRecorded {
            logger.debug("administrationAlreadyRecorded")
            let response = LogMedicationIntentResponse(code: .alreadyLogged, userActivity: nil)
            response.medicationName = medicationName
            return response
        } catch {
            logger.error(error)
            let response = LogMedicationIntentResponse(code: .failure, userActivity: nil)
            response.medicationName = medicationName
            return response
        }
    }

    private func logMedication(named medicationName: String) async throws {
        try await application.recordAdministration(medicationName: medicationName)
    }

    func resolveMedication(for intent: LogMedicationIntent) async -> INStringResolutionResult {
        if let medication = intent.medication, !medication.isEmpty {
            return .success(with: medication)
        }

        do {
            let response = try await application.getTrackedMedications(date: Date.current)
            if response.medications.count == 1 {
                let medicationName = response.medications[0].name
                return .success(with: medicationName)
            }
        } catch {
            logger.error(error)
        }

        return .needsValue()
    }
}
