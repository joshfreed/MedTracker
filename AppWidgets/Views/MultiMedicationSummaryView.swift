import SwiftUI
import WidgetKit

struct MultiMedicationSummaryView: View {
    var entry: SimpleEntry

    var medicationCount: Int { entry.medications.count }

    var administeredCount: Int {
        entry.medications.filter { $0.wasAdministeredToday }.count
    }

    var body: some View {
        if medicationCount == 0 {
            Text("No medications being tracked")
        } else if administeredCount == 0 {
            Text("You need to take your medication!")
        } else if administeredCount == medicationCount {
            Text("You have taken all of your medications!!!!")
        } else {
            Text("You have taken \(administeredCount) of \(medicationCount) medications")
        }
    }
}

struct MultiMedicationSummaryView_Previews: PreviewProvider {
    static let noneTaken: [DailyMedication] = [
        .init(medicationName: "", wasAdministeredToday: false),
        .init(medicationName: "", wasAdministeredToday: false),
    ]

    static let someTaken: [DailyMedication] = [
        .init(medicationName: "", wasAdministeredToday: false),
        .init(medicationName: "", wasAdministeredToday: true),
    ]

    static let allTaken: [DailyMedication] = [
        .init(medicationName: "", wasAdministeredToday: true),
        .init(medicationName: "", wasAdministeredToday: true),
    ]

    static var previews: some View {
        MultiMedicationSummaryView(entry: .init(date: Date(), medications: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        MultiMedicationSummaryView(entry: .init(date: Date(), medications: noneTaken))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        MultiMedicationSummaryView(entry: .init(date: Date(), medications: someTaken))
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        MultiMedicationSummaryView(entry: .init(date: Date(), medications: allTaken))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
