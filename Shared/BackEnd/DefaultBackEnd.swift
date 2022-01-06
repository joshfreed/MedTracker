import Foundation
import Combine
import MedicationApp

class DefaultBackEnd: MedTrackerBackEnd {
    private let trackMedication: TrackMedicationUseCase
    private let getTrackedMedicationsQuery: GetTrackedMedicationsContinuousQuery
    private let recordAdministrationUseCase: RecordAdministrationUseCase
    private let removeAdministrationUseCase: RemoveAdministrationUseCase

    init(
        trackMedication: TrackMedicationUseCase,
        getTrackedMedications: GetTrackedMedicationsContinuousQuery,
        recordAdministration: RecordAdministrationUseCase,
        removeAdministration: RemoveAdministrationUseCase
    ) {
        self.trackMedication = trackMedication
        self.getTrackedMedicationsQuery = getTrackedMedications
        self.recordAdministrationUseCase = recordAdministration
        self.removeAdministrationUseCase = removeAdministration
    }

    func trackMedication(name: String, administrationTime: Int) async throws {
        let command = TrackMedicationCommand(name: name, administrationTime: 9)
        try await trackMedication.handle(command)
    }

    func getTrackedMedications(date: Date) -> AnyPublisher<GetTrackedMedicationsResponse, Error> {
        getTrackedMedicationsQuery.subscribe(.init(date: date))
    }

    func recordAdministration(medicationId: String) async throws {
        try await recordAdministrationUseCase.handle(RecordAdministrationCommand(medicationId: medicationId))
    }

    func removeAdministration(medicationId: String) async throws {
        try await removeAdministrationUseCase.handle(RemoveAdministrationCommand(medicationId: medicationId))
    }
}
