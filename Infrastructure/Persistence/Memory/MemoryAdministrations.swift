import Foundation
import MedicationApp

class MemoryAdministrations: AdministrationRepository {
    func add(_ administration: Administration) async throws {
        MemoryDatabase.shared.administrations.append(administration)
    }

    func save() async throws {}

    func hasAdministration(on date: Date, for medicationId: MedicationId) async throws -> Bool {
        MemoryDatabase.shared.administrations.contains { $0.medicationId == medicationId }
    }
}
