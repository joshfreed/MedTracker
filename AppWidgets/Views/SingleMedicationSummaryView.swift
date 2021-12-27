import SwiftUI
import WidgetKit

struct SingleMedicationSummaryView: View {
    var entry: SimpleEntry

    var wasAdministered: Bool {
        entry.medications.first?.wasAdministeredToday ?? false
    }

    var body: some View {
        Text("Hello, World!")
    }
}

struct SingleMedicationSummaryView_Previews: PreviewProvider {
    static let notTaken: [DailyMedication] = [.init(medicationName: "", wasAdministeredToday: false)]

    static let taken: [DailyMedication] = [.init(medicationName: "", wasAdministeredToday: true)]

    static var previews: some View {
        SingleMedicationSummaryView(entry: .init(date: Date(), medications: notTaken))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        SingleMedicationSummaryView(entry: .init(date: Date(), medications: taken))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
