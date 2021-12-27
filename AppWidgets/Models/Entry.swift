import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let medications: [DailyMedication]

    func clearAdministrations(date: Date) -> SimpleEntry {
        var tomorrowMedications = medications
        for i in 0..<tomorrowMedications.count {
            tomorrowMedications[i].reset()
        }
        return SimpleEntry(date: date, medications: tomorrowMedications)
    }
}

struct DailyMedication {
    let medicationName: String
    private(set) var wasAdministeredToday: Bool

    mutating func reset() {
        wasAdministeredToday = false
    }
}
