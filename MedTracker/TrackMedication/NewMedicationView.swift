import SwiftUI

struct NewMedicationView: View {
    @StateObject var vm = NewMedicationViewModel()
    @Environment(\.dismiss) var dismiss
    @FocusState private var isFocused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                TextField("Medication Name", text: $vm.name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                    .padding([.leading, .trailing])
                    .focused($isFocused)

                Button {
                    Task {
                        await vm.submit()
                    }
                } label: {
                    Text("Start Tracking")
                }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Spacer()
            }
            .padding(.top, 16)
            .navigationTitle("Track a Medication")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .background(Color("Schedule Background").ignoresSafeArea())
            .onChange(of: vm.medicationTracked) { isMedicationTracked in
                if isMedicationTracked {
                    dismiss()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isFocused = true
                }
            }
        }
    }
}

struct NewMedicationView_Previews: PreviewProvider {
    static var previews: some View {
        NewMedicationView()
    }
}
