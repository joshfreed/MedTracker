import Foundation
import Intents

class LogMedicationIntentHandler: NSObject, LogMedicationIntentHandling {
    func handle(intent: LogMedicationIntent) async -> LogMedicationIntentResponse {
        // TODO: Log the medication's administration

        return .init(code: .success, userActivity: nil)
    }

    func resolveMedication(for intent: LogMedicationIntent) async -> INStringResolutionResult {
        if let medication = intent.medication, !medication.isEmpty {
            return .success(with: medication)
        } else {
            return .needsValue()
        }
    }
}
