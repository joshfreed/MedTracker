import Foundation
import MedicationApp

class MemoryMedications: MedicationRepository {
    func add(_ medication: Medication) async throws {
        MemoryDatabase.shared.medications.append(medication)
    }

    func getAll() async throws -> [Medication] {
        MemoryDatabase.shared.medications
    }

    func getById(_ id: MedicationId) async throws -> Medication? {
        MemoryDatabase.shared.medications.first { $0.id == id }
    }

    func save() async throws {}
}
