import Foundation
import MedicationApp
import OSLog

protocol MedTrackerApp {
    func getTrackedMedications() async -> [DailyMedication]
}

class DefaultMedTrackerApp: MedTrackerApp {
    private let logger = Logger.widget
    
    private lazy var medicationService: MedicationService = {
        let context = PersistenceController.shared.container.viewContext

        return MedicationService(
            medications: CoreDataMedications(context: context),
            administrations: CoreDataAdministrations(context: context),
            shortcutDonation: EmptyDonationService()
        )
    }()

    func getTrackedMedications() async -> [DailyMedication] {
        do {
            let response = try await medicationService.handle(GetTrackedMedicationsQuery(date: Date()))
            return response.medications.map {
                .init(medicationName: $0.name, wasAdministeredToday: $0.wasAdministered)
            }
        } catch {
            logger.error(error)
            return []
        }
    }
}
