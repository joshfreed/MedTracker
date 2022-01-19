//
//  AppIntentsApplication.swift
//  AppIntents
//
//  Created by Josh Freed on 1/14/22.
//

import Foundation
import MTBackEndCore
import MedicationContext

/// Application facade for use by the AppIntents target
protocol AppIntentsApplication {
    func getTrackedMedications(date: Date) async throws -> GetTrackedMedicationsResponse
    func recordAdministration(medicationName: String) async throws
}

class AppIntentsFacade: AppIntentsApplication {
    private let backEnd: MedTrackerBackEnd

    init(backEnd: MedTrackerBackEnd) {
        self.backEnd = backEnd
    }

    func getTrackedMedications(date: Date) async throws -> GetTrackedMedicationsResponse {
        try await backEnd.getTrackedMedications(date: date)
    }

    func recordAdministration(medicationName: String) async throws {
        try await backEnd.recordAdministration(medicationName: medicationName)
    }
}
