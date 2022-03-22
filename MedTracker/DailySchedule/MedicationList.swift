import SwiftUI

struct MedicationList: View {
    @Binding var medications: [DailySchedule.Medication]
    @State private var isEditingMedication = false
    @State private var selectedMedicationId: String? = nil

    var body: some View {
        VStack {
            ForEach($medications) { $med in
                DailyMedicationView(medication: med.name, wasAdministered: $med.wasAdministered) {
                    isEditingMedication = true
                    selectedMedicationId = med.id
                }
                    .accessibilityElement(children: .contain)
                    .accessibilityIdentifier("Medication Entry: \(med.name)")
            }
        }
        .padding([.leading, .trailing], 16)
        .sheet(isPresented: $isEditingMedication) {
            if let medicationId = selectedMedicationId {
                EditMedicationView(medicationId: medicationId)
            }
        }
    }
}

struct MedicationList_Previews: PreviewProvider {
    static var medications: [DailySchedule.Medication] = [
        .init(
            id: "A",
            name: "Lexapro",
            wasAdministered: false
        ),
        .init(
            id: "B",
            name: "Allegra",
            wasAdministered: false
        ),
    ]

    static var previews: some View {
        MedicationList(medications: .constant(medications))
    }
}
