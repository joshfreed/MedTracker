import WidgetKit

struct DailySummaryEntry: TimelineEntry {
    let date: Date
    let medications: [TrackedMedication]
}

struct TrackedMedication {
    let medicationName: String
    let wasAdministeredToday: Bool

    func notAdministered() -> TrackedMedication {
        .init(medicationName: medicationName, wasAdministeredToday: false)
    }
}
