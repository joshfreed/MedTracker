import WidgetKit
import SwiftUI

struct AppWidgetsEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: SimpleEntry

    var body: some View {
        switch family {
        case .systemSmall: DailySummaryView(entry: entry)
//        case .systemMedium: Text(entry.date, style: .time)
//        case .systemLarge: Text(entry.date, style: .time)
//        case .systemExtraLarge: Text(entry.date, style: .time)
        default: Text("Unsupported family: \(family.rawValue)")
        }
    }
}

struct AppWidgetsEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AppWidgetsEntryView(entry: SimpleEntry(date: Date(), medications: []))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
