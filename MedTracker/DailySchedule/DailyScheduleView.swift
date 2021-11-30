//
//  DailyScheduleView.swift
//  MedTracker
//
//  Created by Josh Freed on 11/28/21.
//

import SwiftUI

struct DailyScheduleView: View {
    @StateObject var vm = DailyScheduleViewModel()
    
    var body: some View {
        NavigationView {
            MedicationList(medications: vm.medications)
                .navigationTitle(vm.date)
        }
        .task {
            vm.load()
        }
    }
}

struct DailyScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        DailyScheduleView()
    }
}
