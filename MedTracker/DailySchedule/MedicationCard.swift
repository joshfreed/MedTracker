//
//  MedicationCard.swift
//  MedTracker
//
//  Created by Josh Freed on 11/28/21.
//

import SwiftUI

struct MedicationCard: View {
    let medication: String
    let wasAdministered: Bool

    @State private var administered = false

    var body: some View {
        VStack {
//            if administered {
                AdministrationRecordedView(medication: medication)
                    .card()
//            } else {
                MedicationPromptView(medication: medication, wasAdministered: $administered)
                    .card()
//            }
        }
    }
}

struct MedicationCard_Previews: PreviewProvider {
    static var previews: some View {
        MedicationCard(medication: "Testapril", wasAdministered: false)
            .padding()
            .background(.gray)
            .previewLayout(.sizeThatFits)
    }
}
