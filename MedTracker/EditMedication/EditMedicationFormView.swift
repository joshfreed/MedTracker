import SwiftUI

struct EditMedicationFormView: View {
    @Binding var name: String
    @Binding var remindersEnabled: Bool
    @Binding var reminderTime: Date
    
    var body: some View {
        VStack {
            Text(name)
            Toggle("Reminder?", isOn: $remindersEnabled)
            if remindersEnabled {
                DatePicker("Reminder Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
            }
            Spacer()
        }
        .padding()
    }
}

struct EditMedicationFormView_Previews: PreviewProvider {
    struct ShimView: View {
        @State var name: String = "Meddy"
        @State var remindersEnabled: Bool = true
        @State var reminderTime: Date = Calendar.current.date(from: .init(hour: 9, minute: 0))!

        var body: some View {
            EditMedicationFormView(
                name: $name,
                remindersEnabled: $remindersEnabled,
                reminderTime: $reminderTime
            )
        }
    }

    static var previews: some View {
        ShimView()
    }
}
