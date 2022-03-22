import SwiftUI

struct AdministrationRecordedView: View {
    let medication: String

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 28))
                .foregroundColor(.white)

            Text("You have taken your \(medication) today")
                .foregroundColor(.white)
        }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.green)
            }
    }
}

struct AdministrationRecordedView_Previews: PreviewProvider {
    static var previews: some View {
        AdministrationRecordedView(medication: "Testprazin")
            .previewLayout(.sizeThatFits)
    }
}
