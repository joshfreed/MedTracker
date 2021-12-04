import Foundation
import OSLog
import JFLib_Services
import MedicationApp

class NewMedicationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var medicationTracked = false
    @Published var errorTrackingMedication = false

    @Injected private var trackMedication: TrackMedicationUseCase

    func submit() async {
        medicationTracked = false
        errorTrackingMedication = false

        let command = TrackMedicationCommand(name: name)

        do {
            try await trackMedication.handle(command)
            medicationTracked = true
        } catch {
            Logger.trackMedication.error(error)
            errorTrackingMedication = true
            fatalError("\(error)")
        }
    }
}
