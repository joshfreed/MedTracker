//
//  MedicationList.swift
//  MedTracker
//
//  Created by Josh Freed on 11/30/21.
//

import SwiftUI

struct MedicationList: View {
    let medications: [Medication]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(medications) { med in
                    MedicationCard(medication: med.name, schedule: med.frequency, administrations: med.administrations)
                }

                Spacer()
            }
            .padding(.top, 16)
            .padding([.leading, .trailing], 8)
        }
        .background(Color("Schedule Background").ignoresSafeArea())
    }
}

struct MedicationList_Previews: PreviewProvider {
    static var medications: [Medication] = [
        .init(
            name: "Lexapro",
            frequency: "BID",
            administrations: [
                .init(time: "9am Dose", wasAdministered: true),
                .init(time: "5pm Dose", wasAdministered: false)
            ]
        ),
        .init(
            name: "Allegra",
            frequency: "Daily",
            administrations: [
                .init(time: "9am Dose", wasAdministered: true),
            ]
        ),
    ]

    static var previews: some View {
        MedicationList(medications: medications)
    }
}
