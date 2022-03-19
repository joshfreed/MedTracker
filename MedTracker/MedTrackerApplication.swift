import Foundation
import Combine
import MTBackEndCore
import MedicationContext

/// Application facade for use in iOS, ipadOS, or macOS targets
protocol MedTrackerApplication {
    
    // Medications
    func trackMedication(name: String, administrationTime: Int) async throws
    func getTrackedMedications(date: Date) -> AnyPublisher<GetTrackedMedicationsResponse, Error>
    func getTrackedMedications(date: Date) async throws -> GetTrackedMedicationsResponse
    func recordAdministration(medicationId: String) async throws
    func recordAdministration(medicationName: String) async throws
    func removeAdministration(medicationId: String) async throws

    // Reminders
    func scheduleReminderNotifications() async throws
}

class ApplicationFacade: MedTrackerApplication {
    private let backEnd: MedTrackerBackEnd

    init(backEnd: MedTrackerBackEnd) {
        self.backEnd = backEnd
    }
}

// MARK: - Medications

extension ApplicationFacade {
    func trackMedication(name: String, administrationTime: Int) async throws {
        try await backEnd.trackMedication(name: name, administrationTime: administrationTime)
    }

    func getTrackedMedications(date: Date) -> AnyPublisher<GetTrackedMedicationsResponse, Error> {
        backEnd.getTrackedMedications(date: date)
    }

    func getTrackedMedications(date: Date) async throws -> GetTrackedMedicationsResponse {
        try await backEnd.getTrackedMedications(date: date)
    }

    func recordAdministration(medicationId: String) async throws {
        try await backEnd.recordAdministration(medicationId: medicationId)
    }

    func recordAdministration(medicationName: String) async throws {
        try await backEnd.recordAdministration(medicationName: medicationName)
    }

    func removeAdministration(medicationId: String) async throws {
        try await backEnd.removeAdministration(medicationId: medicationId)
    }
}

// MARK: - Reminders

extension ApplicationFacade {
    func scheduleReminderNotifications() async throws {
        try await backEnd.scheduleReminderNotifications()
    }
}
