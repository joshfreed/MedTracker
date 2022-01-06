import Foundation
import Combine
import MedicationApp

class PreviewBackEnd: MedTrackerBackEnd {
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

    func recordAdministration(medicationId: String) async throws {}

    func removeAdministration(medicationId: String) async throws {}
}
