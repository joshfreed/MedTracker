import Foundation
import MedicationApp

var administrations: [Administration] = []

class MemoryAdministrations: AdministrationRepository {
    func add(_ administration: Administration) async throws {
        administrations.append(administration)
    }

    func save() async throws {}

    func hasAdministration(on date: Date, for medicationId: MedicationId) async throws -> Bool {
        administrations.contains { $0.medicationId == medicationId }
    }
}
