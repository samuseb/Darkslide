import SwiftUI

struct DSMultilineTextField: View {
    private enum Constants {
        static let cornerRadius = 8.0
        static let defaultHeight = 150.0
    }

    var placeHolder: String
    @Binding var text: String
    var height = Constants.defaultHeight

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .foregroundColor(Color(asset: Asset.Colors.lightGray))

            VStack {
                TextField(String.empty, text: $text, axis: .vertical)
                    .placeholder(when: text.isEmpty, placeholder: {
                        Text(placeHolder)
                            .foregroundColor(.gray)
                    })
                    .disableAutocorrection(true)
                    .padding()
                    .defaultDarkText()
                Spacer()
            }
        }
        .frame(height: height)

    }
}

struct DSMultilineTextField_Previews: PreviewProvider {
    static var previews: some View {
        DSMultilineTextField(placeHolder: "Placeholder", text: .constant(String.empty))
    }
}
