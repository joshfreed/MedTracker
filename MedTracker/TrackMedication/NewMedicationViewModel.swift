import Foundation
import OSLog
import JFLib_Services

class NewMedicationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var medicationTracked = false
    @Published var errorTrackingMedication = false

    @Injected private var backEnd: MedTrackerApplication

    init() {}

    init(backEnd: MedTrackerApplication) {
        self.backEnd = backEnd
    }

    func submit() async {
        medicationTracked = false
        errorTrackingMedication = false

        do {
            try await backEnd.trackMedication(name: name, administrationTime: 9)
            medicationTracked = true
        } catch {
            Logger.trackMedication.error(error)
            errorTrackingMedication = true
            fatalError("\(error)")
        }
    }
}

// MARK: - Preview

extension NewMedicationViewModel {
    static func preview() -> NewMedicationViewModel {
        NewMedicationViewModel(backEnd: .preview())
    }
}
