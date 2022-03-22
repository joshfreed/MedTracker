import SwiftUI

struct TrackMedicationButton: View {
    @State private var isAddingMedication = false

    var body: some View {
        Button {
            isAddingMedication = true
        } label: {
            Text("Track a Medication")
                .frame(maxWidth: .infinity)
        }
        .tint(.blue)
        .buttonStyle(.bordered)
        .controlSize(.large)
        .padding([.leading, .trailing], 16)
        .accessibilityIdentifier("trackMedication")
        .sheet(isPresented: $isAddingMedication) {
            NewMedicationView()
        }
    }
}

struct TrackMedicationButton_Previews: PreviewProvider {
    static var previews: some View {
        TrackMedicationButton()
    }
}
