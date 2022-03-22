import Foundation
import Combine
import MedicationContext
import MTBackEndCore

class PreviewApplication: MedTrackerBackEnd {
    func trackMedication(name: String, administrationTime: Int) async throws {}

    func getTrackedMedications(date: Date) -> AnyPublisher<GetTrackedMedicationsResponse, Error> {
        let medications: [GetTrackedMedicationsResponse.Medication] = [
            .init(id: "A", name: "Lexapro", wasAdministered: false),
            .init(id: "B", name: "Allegra", wasAdministered: true),
        ]
        return Just(.init(date: Date(), medications: medications))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func getTrackedMedications(date: Date) async throws -> GetTrackedMedicationsResponse {
        fatalError("getTrackedMedications(date:) has not been implemented")
    }

    func recordAdministration(medicationId: String) async throws {}

    func recordAdministration(medicationName: String) async throws {}

    func removeAdministration(medicationId: String) async throws {}

    func scheduleReminderNotifications() async throws {}
}
