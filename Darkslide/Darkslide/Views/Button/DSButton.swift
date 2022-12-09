import SwiftUI

struct DSButton: View {
    private enum Constants {
        static let cornerRadius = 8.0
        static let disabledOpacity = 0.3
        static let defaultHeight = 40.0
    }

    var text: String
    var height: CGFloat = Constants.defaultHeight
    @Binding var isDisabled: Bool
    var style: DSButtonStyle = .basic
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundColor(
                        style == .basic ?
                        Color(asset: Asset.Colors.controlTint) :
                        .red
                    )
                    .frame(height: height)
                Text(text)
                    .bold()
                    .defaultText()
            }
            .opacity(isDisabled ? Constants.disabledOpacity : 1)
        }
        .disabled(isDisabled)
    }
}

struct DSButton_Previews: PreviewProvider {
    static var previews: some View {
        DSButton(text: "Register", isDisabled: .constant(false)) { }
    }
}

enum DSButtonStyle {
    case basic, destructive
}
