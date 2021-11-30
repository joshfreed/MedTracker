//
//  ScheduleSlotView.swift
//  MedTracker
//
//  Created by Josh Freed on 11/28/21.
//

import SwiftUI

struct ScheduleSlotView: View {
    let time: String
    let wasAdministered: Bool
    @State var isOn: Bool = false

    var body: some View {
        HStack {
//            Text(time)
//            Spacer()
//            Text(wasAdministered ? "Yes" : "No")
            Toggle(time, isOn: $isOn)
        }
        .padding()
    }
}

struct ScheduleSlotView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleSlotView(time: "9am Dose", wasAdministered: false).previewLayout(.sizeThatFits)
        ScheduleSlotView(time: "9am Dose", wasAdministered: true).previewLayout(.sizeThatFits)
    }
}
