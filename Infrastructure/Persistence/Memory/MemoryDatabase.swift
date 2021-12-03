import Foundation
import MedicationApp

final class MemoryDatabase {
    static let shared = MemoryDatabase()

    var medications: [Medication] = []
    var administrations: [Administration] = []

    private init() {}
}
