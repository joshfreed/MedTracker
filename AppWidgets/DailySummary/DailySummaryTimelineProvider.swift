import WidgetKit
import OSLog

struct DailySummaryTimelineProvider: TimelineProvider {
    private let medTrackerApp: GetDailySummaryQuery
    private let logger = Logger.widget

    init(medTrackerApp: GetDailySummaryQuery) {
        self.medTrackerApp = medTrackerApp
    }

    func placeholder(in context: Context) -> DailySummaryEntry {
        DailySummaryEntry(date: Date(), medications: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (DailySummaryEntry) -> ()) {
        if context.isPreview {
            logger.info("Get Preview Snapshot")
            let entry = DailySummaryEntry(date: Date(), medications: [
                .init(medicationName: "Happy Pills", wasAdministeredToday: false)
            ])
            completion(entry)
        } else {
            logger.info("Get Live Snapshot")
            Task {
                let currentMedications = await medTrackerApp.getTrackedMedications()
                let entry = DailySummaryEntry(date: Date(), medications: currentMedications)
                completion(entry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailySummaryEntry>) -> ()) {
        logger.info("Build Timeline")

        Task {
            let currentMedications = await medTrackerApp.getTrackedMedications()
            let clearedMedications = currentMedications.map { $0.notAdministered() }

            let nowEntry = DailySummaryEntry(date: Date(), medications: currentMedications)
            let tomorrowEntry = DailySummaryEntry(date: getTomorrowDate(), medications: clearedMedications)

            // Build Timeline
            var entries: [DailySummaryEntry] = []
            entries.append(nowEntry)
            entries.append(tomorrowEntry)
            let timeline = Timeline(entries: entries, policy: .never)

            completion(timeline)
        }
    }

    private func getTomorrowDate() -> Date {
        let midnight = Calendar.current.startOfDay(for: Date.current)
        return Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    }
}
