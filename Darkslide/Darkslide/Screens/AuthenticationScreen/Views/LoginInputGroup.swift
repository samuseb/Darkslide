import SwiftUI

struct LoginInputGroup: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var buttonDisabled: Bool
    var loginAction: () -> Void

    var body: some View {
        VStack {
            DSTextField(placeHolder: L10n.Authentication.email, text: $email)
                .padding(.horizontal, Layout.padding20)
                .padding(.vertical, Layout.padding5)
            DSTextField(placeHolder: L10n.Authentication.password, isSecure: true, text: $password)
                .padding(.horizontal, Layout.padding20)
                .padding(.vertical, Layout.padding5)
            DSButton(text: L10n.Authentication.login, isDisabled: $buttonDisabled) {
                loginAction()
            }
            .padding(.top, Layout.padding10)
            .padding(.horizontal, Layout.padding30)
        }
    }
}

struct LoginInputGroup_Previews: PreviewProvider {
    static var previews: some View {
        LoginInputGroup(
            email: .constant(String.empty),
            password: .constant(String.empty),
            buttonDisabled: .constant(true)
        ) { }
    }
}
