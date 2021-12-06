import Foundation
import MedicationApp

class MemoryAdministrations: AdministrationRepository {
    func add(_ administration: Administration) async throws {
        MemoryDatabase.shared.administrations.append(administration)
    }

    func findBy(medicationId: MedicationId, and date: Date) async throws -> Administration? {
        MemoryDatabase.shared.administrations.first { $0.medicationId == medicationId }
    }

    func hasAdministration(on date: Date, for medicationId: MedicationId) async throws -> Bool {
        MemoryDatabase.shared.administrations.contains { $0.medicationId == medicationId }
    }

    func remove(_ administration: Administration) async throws {
        fatalError("Not implemented")
    }

    func save() async throws {}
}
