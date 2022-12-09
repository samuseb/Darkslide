import SwiftUI

struct RegisterInputGroup: View {
    @Binding var email: String
    @Binding var username: String
    @Binding var password: String
    @Binding var buttonDisabled: Bool

    var registerAction: () -> Void

    var body: some View {
        VStack {
            DSTextField(placeHolder: L10n.Authentication.email, text: $email)
                .padding(.horizontal, Layout.padding20)
                .padding(.vertical, Layout.padding2)
            DSTextField(placeHolder: L10n.CreateName.placeholder, text: $username)
                .padding(.horizontal, Layout.padding20)
                .padding(.vertical, Layout.padding2)
            DSTextField(placeHolder: L10n.Authentication.password, isSecure: true, text: $password)
                .padding(.horizontal, Layout.padding20)
                .padding(.vertical, Layout.padding2)
            DSButton(text: L10n.Authentication.register, isDisabled: $buttonDisabled) {
                registerAction()
            }
            .padding(.top, Layout.padding10)
            .padding(.horizontal, Layout.padding30)
        }
    }
}

struct RegisterInputGroup_Previews: PreviewProvider {
    static var previews: some View {
        RegisterInputGroup(
            email: .constant(String.empty),
            username: .constant(String.empty),
            password: .constant(String.empty),
            buttonDisabled: .constant(false)
        ) { }
    }
}
