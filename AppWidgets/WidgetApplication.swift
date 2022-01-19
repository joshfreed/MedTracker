import Foundation
import OSLog
import MTBackEndCore

protocol WidgetApplication {
    /// Returns all the actively tracked medications and whether each was administered today
    func getTrackedMedications() async -> [TrackedMedication]
}

class WidgetApplicationFacade: WidgetApplication {
    private let logger = Logger.widget
    private let backEnd: MedTrackerBackEnd

    init(backEnd: MedTrackerBackEnd) {
        self.backEnd = backEnd
    }

    func getTrackedMedications() async -> [TrackedMedication] {
        do {
            let response = try await backEnd.getTrackedMedications(date: Date())
            return response.medications.map {
                .init(medicationName: $0.name, wasAdministeredToday: $0.wasAdministered)
            }
        } catch {
            logger.error(error)
            return []
        }
    }
}
