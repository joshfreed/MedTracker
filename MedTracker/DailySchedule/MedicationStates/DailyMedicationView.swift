//
//  DailyMedicationView.swift
//  MedTracker
//
//  Created by Josh Freed on 12/2/21.
//

import SwiftUI

struct DailyMedicationView: View {
    let medication: String
    @Binding var wasAdministered: Bool
    var onEdit: () -> Void = {}

    var body: some View {
        HStack {
            HStack {
                Text(medication)
                Spacer()
                Image(systemName: wasAdministered ? "checkmark.circle" : "circle")
                    .accessibilityIdentifier("administrationState")
                    .accessibilityValue(wasAdministered ? "Administered" : "Not Administered")
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    wasAdministered.toggle()
                }
            }
            .card()

            Button(action: {
                onEdit()
            }) {
                Image(systemName: "pencil")
                    .padding()
                    .card()
            }
        }
    }
}

struct DailyMedicationView_Previews: PreviewProvider {
    struct ShimView: View {
        @State private var wasAdministered = false

        var body: some View {
            DailyMedicationView(medication: "Testapraxin", wasAdministered: $wasAdministered)
                .background(Color.gray)
        }
    }

    static var previews: some View {
        ShimView()
            .previewLayout(.sizeThatFits)
    }
}
