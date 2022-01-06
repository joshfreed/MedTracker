import Foundation
import Combine
import MedicationApp

class MedTrackerApplication {
    private let backEnd: MedTrackerBackEnd

    init(backEnd: MedTrackerBackEnd) {
        self.backEnd = backEnd
    }

    func trackMedication(name: String, administrationTime: Int) async throws {
        try await backEnd.trackMedication(name: name, administrationTime: administrationTime)
    }

    func getTrackedMedications(date: Date) -> AnyPublisher<GetTrackedMedicationsResponse, Error> {
        backEnd.getTrackedMedications(date: date)
    }

    func recordAdministration(medicationId: String) async throws {
        try await backEnd.recordAdministration(medicationId: medicationId)
    }

    func removeAdministration(medicationId: String) async throws {
        try await backEnd.removeAdministration(medicationId: medicationId)
    }
}

extension MedTrackerApplication {
    static func preview() -> MedTrackerApplication {
        .init(backEnd: PreviewBackEnd())
    }
}
