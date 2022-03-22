import SwiftUI

struct EditMedicationView: View {
    @StateObject var vm = EditMedicationViewModel()
    let medicationId: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            EditMedicationFormView(
                name: $vm.name,
                remindersEnabled: $vm.remindersEnabled,
                reminderTime: $vm.reminderTime
            )
                .navigationTitle("Edit Medication")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) { Text("Cancel") }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            Task {
                                await vm.updateMedication()
                                dismiss()
                            }
                        }) { Text("Save") }
                    }
                }
        }
        .task {
            await vm.load(medicationId: medicationId)
        }
    }
}

struct EditMedicationView_Previews: PreviewProvider {
    static var previews: some View {
        EditMedicationView(medicationId: "")
    }
}
