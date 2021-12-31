import Foundation

/// Fetch a daily summary from MedTrackerBiz
protocol GetDailySummaryQuery {
    /// Returns all the actively tracked medications and whether each was administered today
    func getTrackedMedications() async -> [TrackedMedication]
}

