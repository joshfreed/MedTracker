import Foundation
import JFLib_Services
import MedicationApp

class NewMedicationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var medicationTracked = false
    @Published var errorTrackingMedication = false

    @Injected private var trackMedication: TrackMedicationUseCase

    init() {
        print("NewMedicationViewModel::init")
    }

    deinit {
        print("NewMedicationViewModel::deinit")
    }

    func submit() async {
        medicationTracked = false
        errorTrackingMedication = false

        let command = TrackMedicationCommand(name: name)

        do {
            try await trackMedication.handle(command)
            medicationTracked = true
        } catch {
            errorTrackingMedication = true
            fatalError("\(error)")
        }
    }
}
