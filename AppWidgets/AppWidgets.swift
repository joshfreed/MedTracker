import WidgetKit
import SwiftUI
import Dip
import JFLib_Services
import Common
import DefaultBackEnd

@main
struct AppWidgets: Widget {
    let kind: String = "com.medtracker.daily-summary"
    let backEndModule = BackEndModule()
    var widgetApplication: WidgetApplication { try! JFServices.resolve() }

    init() {
        let container = DipContainer()
        backEndModule.registerServices(env: .live, container: container.container)
        container.container.register(.unique) { WidgetApplicationFacade(backEnd: $0) }.implements(WidgetApplication.self)
        JFServices.initialize(container: container)
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: DailySummaryTimelineProvider(medTrackerApp: widgetApplication)
        ) { entry in
            DailySummaryView(entry: entry)
        }
        .configurationDisplayName("Daily Summary")
        .description("View your progress on today's medications.")
    }
}
