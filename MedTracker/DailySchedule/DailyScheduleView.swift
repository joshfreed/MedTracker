import SwiftUI

struct DailyScheduleView: View {
    @StateObject var vm = DailyScheduleViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                MedicationList(medications: $vm.medications)
            }
            .background(Color("Schedule Background").ignoresSafeArea())
            .navigationTitle(vm.date)
        }
        .task {
            await vm.load()
        }
    }
}

struct DailyScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        DailyScheduleView(vm: .fake())
    }
}
