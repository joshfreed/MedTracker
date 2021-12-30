import WidgetKit
import OSLog

struct Provider: TimelineProvider {
    private let medTrackerApp: MedTrackerApp
    private let logger = Logger.widget

    init(medTrackerApp: MedTrackerApp) {
        self.medTrackerApp = medTrackerApp
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), medications: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        if context.isPreview {
            logger.info("Get Preview Snapshot")
            let entry = SimpleEntry(date: Date(), medications: [
                .init(medicationName: "Happy Pills", wasAdministeredToday: false)
            ])
            completion(entry)
        } else {
            logger.info("Get Live Snapshot")
            Task {
                let currentMedications = await medTrackerApp.getTrackedMedications()
                let entry = SimpleEntry(date: Date(), medications: currentMedications)
                completion(entry)
            }
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        logger.info("Build Timeline")

        Task {
            let currentMedications = await medTrackerApp.getTrackedMedications()
            let clearedMedications = currentMedications.map { $0.notAdministered() }

            let nowEntry = SimpleEntry(date: Date(), medications: currentMedications)
            let tomorrowEntry = SimpleEntry(date: getTomorrowDate(), medications: clearedMedications)

            // Build Timeline
            var entries: [SimpleEntry] = []
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
