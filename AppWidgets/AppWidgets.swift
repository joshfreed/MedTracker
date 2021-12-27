import WidgetKit
import SwiftUI

@main
struct AppWidgets: Widget {
    let kind: String = "com.medtracker.daily-summary"
    let medTrackerApp: MedTrackerApp = DefaultMedTrackerApp()

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider(medTrackerApp: medTrackerApp)
        ) { entry in
            AppWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
