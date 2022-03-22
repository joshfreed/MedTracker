import Foundation
import JFLib_Services
import MTBackEndCore

class EditMedicationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var remindersEnabled: Bool = true
    @Published var reminderTime = Date()

    @Injected private var application: MedTrackerApplication
    private var medicationId: String!

    init() {}

    init(application: MedTrackerApplication) {
        self.application = application
    }

    func load(medicationId: String) async {
        self.medicationId = medicationId

        do {
            let response = try await application.getEditableMedication(by: medicationId)
            name = response.name
            if let reminderTime = response.reminderTime {
                remindersEnabled = true
                self.reminderTime = reminderTime
            } else {
                remindersEnabled = false
            }
        } catch {

        }
    }

    func updateMedication() async {
        let command = UpdateMedicationCommand(
            medicationId: medicationId,
            name: name,
            reminderTime: remindersEnabled ? reminderTime : nil
        )
        try! await application.updateMedication(command)
    }
}
