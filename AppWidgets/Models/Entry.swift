import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let medications: [DailyMedication]
}

struct DailyMedication {
    let medicationName: String
    let wasAdministeredToday: Bool
}
