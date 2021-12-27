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
            var entries: [SimpleEntry] = []

            let currentMedications = await medTrackerApp.getTrackedMedications()
            let currentEntry = SimpleEntry(date: Date(), medications: currentMedications)
            entries.append(currentEntry)

            let today = Date()
            let midnight = Calendar.current.startOfDay(for: today)
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
            let entry = currentEntry.clearAdministrations(date: tomorrow)
            entries.append(entry)

            let timeline = Timeline(entries: entries, policy: .never)
            completion(timeline)
        }
    }
}
