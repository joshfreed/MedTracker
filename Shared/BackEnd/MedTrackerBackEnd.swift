import Foundation
import Combine
import MedicationApp

protocol MedTrackerBackEnd {
    func trackMedication(name: String, administrationTime: Int) async throws
    func getTrackedMedications(date: Date) -> AnyPublisher<GetTrackedMedicationsResponse, Error>
    func recordAdministration(medicationId: String) async throws
    func removeAdministration(medicationId: String) async throws
}
