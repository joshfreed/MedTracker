import WidgetKit
import SwiftUI

@main
struct AppWidgets: Widget {
    let kind: String = "com.medtracker.daily-summary"
    let medTrackerApp: GetDailySummaryQuery = MedTrackerApp()

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: DailySummaryTimelineProvider(medTrackerApp: medTrackerApp)
        ) { entry in
            DailySummaryView(entry: entry)
        }
        .configurationDisplayName("Daily Summary")
        .description("View your progress on today's medications.")
    }
}
