import SwiftUI

struct FollowButton: View {
    private enum Constants {
        static let cornerRadius = 20.0
        static let lineWidth = 2.0
    }

    var textOff: String = L10n.General.follow
    var textOn: String = L10n.General.unfollow
    @Binding var isOn: Bool
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(isOn ? textOn : textOff)
                .foregroundColor(
                    isOn ?
                    Asset.Colors.controlGray.swiftUIColor :
                        Asset.Colors.controlTint.swiftUIColor
                )
                .padding(.vertical, Layout.padding5)
                .padding(.horizontal, Layout.padding10)
                .background {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .stroke(
                            isOn ?
                            Asset.Colors.controlGray.swiftUIColor :
                            Asset.Colors.controlTint.swiftUIColor,
                            lineWidth: Constants.lineWidth)
                }
        }

    }
}

struct FollowButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FollowButton(isOn: .constant(true)) {}
            FollowButton(isOn: .constant(false)) {}
        }
    }
}
