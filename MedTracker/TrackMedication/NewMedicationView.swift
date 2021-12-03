import SwiftUI

struct NewMedicationView: View {
    @StateObject var vm = NewMedicationViewModel()

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
            .background(
                Color("Schedule Background").ignoresSafeArea()
            )
        }
    }
}

struct NewMedicationView_Previews: PreviewProvider {
    static var previews: some View {
        NewMedicationView()
    }
}
