import SwiftUI
import OSLog

struct DailyScheduleView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var vm = DailyScheduleViewModel()
    @State private var isAddingMedication = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    MedicationList(medications: $vm.medications)
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
                    .sheet(isPresented: $isAddingMedication) {
                        NewMedicationView()
                    }
                }
            }
            .background(Color("Schedule Background").ignoresSafeArea())
            .navigationTitle(vm.date)
        }
        .task {
            vm.load()
        }
        .onChange(of: scenePhase) { phase in
            Logger.dailySchedule.debug("\(String(describing: phase))")
            if phase == .background {
                vm.cancel()
            } else if phase == .active {
                vm.load()
            }
        }
    }
}

struct DailyScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        DailyScheduleView(vm: .preview())
    }
}
