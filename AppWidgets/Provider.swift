import WidgetKit

struct Provider: TimelineProvider {
    private let medTrackerApp: MedTrackerApp

    init(medTrackerApp: MedTrackerApp) {
        self.medTrackerApp = medTrackerApp
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), medications: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), medications: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []

        let currentEntry = SimpleEntry(date: Date(), medications: [])
        entries.append(currentEntry)

        let today = Date()
        let midnight = Calendar.current.startOfDay(for: today)
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entry = SimpleEntry(date: tomorrow, medications: [])
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}
