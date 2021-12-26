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
                            .fill(Color("Card BG"))
                    )
                    .padding([.leading, .trailing])
                    .focused($isFocused)
                    .accessibilityIdentifier("medicationName")

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
                .accessibilityIdentifier("submit")

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
        // Here we've wrapped the view in a ZStack so that it won't be the top-level View in our Preview,
        // to avoid the known bug that causes the `@FocusState` property of a top-level View rendered
        // inside of a Preview, to not work properly.
        ZStack {
            NewMedicationView(vm: .preview())
        }
    }
}
