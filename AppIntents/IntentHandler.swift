import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        guard intent is LogMedicationIntent else {
            fatalError("Unhandled Intent error : \(intent)")
        }

        return LogMedicationIntentHandler()
    }
}
