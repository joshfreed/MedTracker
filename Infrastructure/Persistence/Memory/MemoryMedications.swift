import Foundation
import MedicationApp

class MemoryMedications: MedicationRepository {
    var medications: [Medication] = [
        .init(name: "Lexapro"),
        .init(name: "Allegra"),
        .init(name: "Furosimide"),
    ]

    func getAll() async throws -> [Medication] {
        medications
    }
}
