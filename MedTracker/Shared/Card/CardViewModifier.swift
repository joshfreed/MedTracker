import SwiftUI

struct CardViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("Card BG"))
                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 1, y: 2)
            )
    }
}

extension View {
    func card() -> some View {
        modifier(CardViewModifier())
    }
}
