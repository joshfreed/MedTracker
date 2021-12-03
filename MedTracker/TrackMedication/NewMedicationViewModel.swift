import Foundation
import JFLib_Services
import MedicationApp

class NewMedicationViewModel: ObservableObject {
    @Published var name: String = ""

    @Injected private var trackMedication: TrackMedicationUseCase

    func submit() async {
        let command = TrackMedicationCommand(name: name)

        do {
            try await trackMedication.handle(command)
        } catch {
            fatalError("\(error)")
        }
    }
}
