import Foundation
import MedicationApp

var medications: [Medication] = [
    .init(name: "Lexapro"),
    .init(name: "Allegra"),
    .init(name: "Furosimide"),
]

class MemoryMedications: MedicationRepository {
    func getAll() async throws -> [Medication] {
        medications
    }

    func getById(_ id: MedicationId) async throws -> Medication? {
        medications.first { $0.id == id }
    }
}
