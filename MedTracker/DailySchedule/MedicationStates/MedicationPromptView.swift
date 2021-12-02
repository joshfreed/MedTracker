import SwiftUI

struct MedicationPromptView: View {
    let medication: String
    @Binding var wasAdministered: Bool
    
    var body: some View {
        VStack {
            Text("Have you taken your \(medication) today?")

            HStack {
                Button("Yes!") {
                    withAnimation {
                        wasAdministered = true
                    }
                }
                    .tint(.green)
                    .buttonStyle(.bordered)

                Button("Not Yet") {
                    withAnimation {
                        wasAdministered = false
                    }
                }
                    .tint(.gray)
                    .buttonStyle(.bordered)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct MedicationPromptView_Previews: PreviewProvider {
    static var previews: some View {
        MedicationPromptView(medication: "Testpraxin", wasAdministered: .constant(false))
    }
}
