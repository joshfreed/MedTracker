//
//  MedicationList.swift
//  MedTracker
//
//  Created by Josh Freed on 11/30/21.
//

import SwiftUI

struct MedicationList: View {
    @Binding var medications: [DailySchedule.Medication]

    var body: some View {
        VStack {
            ForEach($medications) { $med in
                DailyMedicationView(medication: med.name, wasAdministered: $med.wasAdministered)
                    .card()
            }
        }
        .padding([.leading, .trailing], 16)
    }
}

struct MedicationList_Previews: PreviewProvider {
    static var medications: [DailySchedule.Medication] = [
        .init(
            id: "A",
            name: "Lexapro",
            wasAdministered: false
        ),
        .init(
            id: "B",
            name: "Allegra",
            wasAdministered: false
        ),
    ]

    static var previews: some View {
        MedicationList(medications: .constant(medications))
    }
}
