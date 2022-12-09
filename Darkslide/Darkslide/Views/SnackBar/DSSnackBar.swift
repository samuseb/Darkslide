import SwiftUI

struct DSSnackBar: View {
    private enum Constants {
        static let minHeight: CGFloat = 50
        static let cornerRadius: CGFloat = 8
    }

    let text: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(text)
                    .defaultText()
                    .padding(Layout.padding10)
                    .frame(minHeight: Constants.minHeight)
                Spacer()
            }
            .background(.ultraThinMaterial)
            .cornerRadius(Constants.cornerRadius)
            .padding(Layout.padding5)

            Spacer()
        }
        .padding(.top, Layout.padding40)
        .frame(maxWidth: .infinity)
        .transition(.move(edge: .top))
    }
}

struct DSSnackBar_Previews: PreviewProvider {
    static var previews: some View {
        Asset.Colors.darkBackground.swiftUIColor
            .ignoresSafeArea()
            .overlay {
                DSSnackBar(
                    text:
                        """
                        Lorem ipsum dolor sit amet, consectetur
                        adipiscing elit, sed do eiusmod tempor
                        incididunt ut labore et dolore magna aliqua.
                        """
                )
            }
    }
}
