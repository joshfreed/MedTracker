import Foundation
import MedicationApp
import JFLib_Services

class UITestHelper {
    func loadMedications() async throws {
        guard let medicationsJson = ProcessInfo.processInfo.environment["medications"] else {
            return
        }

        do {
            let medications = try JSONDecoder().decode([Medication].self, from: Data(medicationsJson.utf8))
            let medicationRepo: MedicationRepository = try JFServices.resolve()
            for medication in medications {
                try await medicationRepo.add(medication)
            }
            try await medicationRepo.save()
        } catch {
            fatalError("\(error)")
        }
    }

    func loadAdministrations() async throws {
        guard let json = ProcessInfo.processInfo.environment["administrations"] else {
            return
        }

        do {
            let models = try JSONDecoder().decode([Administration].self, from: Data(json.utf8))
            let repo: AdministrationRepository = try JFServices.resolve()
            for model in models {
                try await repo.add(model)
            }
            try await repo.save()
        } catch {
            fatalError("\(error)")
        }
    }
}
