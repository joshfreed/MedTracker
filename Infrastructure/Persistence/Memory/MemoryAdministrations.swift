import Foundation
import MedicationApp

class MemoryAdministrations: AdministrationRepository {
    private var administrations: [Administration] = []

    func hasAdministration(on date: Date, for medicationId: MedicationId) async throws -> Bool {
        false
    }
}
