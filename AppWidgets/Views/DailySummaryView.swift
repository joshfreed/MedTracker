import SwiftUI
import WidgetKit

struct DailySummaryView: View {
    var entry: SimpleEntry

    var medicationCount: Int { entry.medications.count }

    var body: some View {
//        if medicationCount == 1 {
//            SingleMedicationSummaryView(entry: entry)
//        } else {
            MultiMedicationSummaryView(entry: entry)
//        }
    }
}

struct DailySummaryView_Previews: PreviewProvider {
    static let medications: [DailyMedication] = [
        .init(medicationName: "", wasAdministeredToday: true),
        .init(medicationName: "", wasAdministeredToday: false),
    ]

    static var previews: some View {
        DailySummaryView(entry: .init(date: Date(), medications: medications))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
