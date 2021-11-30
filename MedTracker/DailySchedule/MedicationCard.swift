//
//  MedicationCard.swift
//  MedTracker
//
//  Created by Josh Freed on 11/28/21.
//

import SwiftUI

struct MedicationCard: View {
    let medication: String
    let schedule: String
    let administrations: [Administration]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(medication)
                    .font(.system(size: 28))
                    .fontWeight(.medium)
                Spacer()
                Text(schedule)
                    .font(.system(size: 16))
                    .fontWeight(.light)
            }
            .padding()

            Divider()

            ForEach(administrations) {
                ScheduleSlotView(time: $0.time, wasAdministered: $0.wasAdministered)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 1, y: 2)
        )
    }
}

struct MedicationCard_Previews: PreviewProvider {
    static var previews: some View {
        MedicationCard(medication: "Lexapro", schedule: "Daily", administrations: [
            .init(time: "9am Dose", wasAdministered: true),
            .init(time: "5pm Dose", wasAdministered: false)
        ])
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
