import SwiftUI
import OSLog

struct DailyScheduleView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var vm = DailyScheduleViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    MedicationList(medications: $vm.medications)

                    TrackMedicationButton()
                }
            }
            .background(Color("Schedule Background").ignoresSafeArea())
            .navigationTitle(vm.date)
        }
        .task {
            await vm.load()
        }
        .onChange(of: scenePhase) { phase in
            Logger.dailySchedule.debug("\(String(describing: phase), privacy: .public)")
            if phase == .background {
                vm.cancel()
            } else if phase == .active {
                Task {
                    await vm.load()
                }
            }
        }
    }
}

struct DailyScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        DailyScheduleView(vm: .preview())
    }
}
