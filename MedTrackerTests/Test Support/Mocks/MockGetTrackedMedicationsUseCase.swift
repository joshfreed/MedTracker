import Foundation
import MedicationApp

class MockGetTrackedMedicationsUseCase: GetTrackedMedicationsUseCase {
    var response: GetTrackedMedicationsResponse = GetTrackedMedicationsResponse(date: Date.current, medications: [])

    func handle(_ query: GetTrackedMedicationsQuery) async throws -> GetTrackedMedicationsResponse {
        return response
    }

    func configure_toReturn(response: GetTrackedMedicationsResponse) {
        self.response = response
    }
}
