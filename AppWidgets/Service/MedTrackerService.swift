import Foundation
import MedicationApp
import OSLog

/// Translates data from MedTrackerBiz and the widgets app
class MedTrackerApp: GetDailySummaryQuery {
    private let logger = Logger.widget

    private lazy var medicationService: MedicationService = {
        let context = PersistenceController.shared.container.viewContext

        return MedicationService(
            medications: CoreDataMedications(context: context),
            administrations: CoreDataAdministrations(context: context),
            shortcutDonation: EmptyDonationService(),
            widgetService: EmptyWidgetService()
        )
    }()

    func getTrackedMedications() async -> [TrackedMedication] {
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
