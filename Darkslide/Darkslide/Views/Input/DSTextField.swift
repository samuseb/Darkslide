import SwiftUI

struct DSTextField: View {
    private enum Constants {
        static let cornerRadius = 8.0
        static let height = 50.0
    }

    let placeHolder: String
    @State var isSecure = false
    @Binding var text: String
    var height = Constants.height

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .frame(height: height)
                .foregroundColor(Color(asset: Asset.Colors.lightGray))
            if isSecure {
                SecureField(String.empty, text: $text)
                    .placeholder(when: text.isEmpty, placeholder: {
                        Text(placeHolder)
                            .foregroundColor(.gray)
                    })
                    .padding()
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .preferredColorScheme(.light)
                    .defaultDarkText()
            } else {
                TextField(String.empty, text: $text)
                    .placeholder(when: text.isEmpty, placeholder: {
                        Text(placeHolder)
                            .foregroundColor(.gray)
                    })
                    .padding()
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .preferredColorScheme(.light)
                    .defaultDarkText()
            }
        }
    }
}

struct DSTextField_Previews: PreviewProvider {
    static var previews: some View {
        DSTextField(placeHolder: "E-mail", text: .constant(""))
    }
}
