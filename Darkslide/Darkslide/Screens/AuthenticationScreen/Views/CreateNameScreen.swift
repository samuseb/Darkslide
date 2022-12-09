import SwiftUI

struct CreateNameScreen: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    let onSuccess: () -> Void

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Spacer()

            Text(L10n.CreateName.title)
                .defaultText()
                .bold()
                .font(.largeTitle)

            DSTextField(placeHolder: L10n.CreateName.placeholder, text: $viewModel.newUsername)
                .padding(.top, Layout.padding40)
            Spacer()
            DSButton(text: L10n.General.save, isDisabled: $viewModel.saveUsernameDisabled) {
                viewModel.saveUsernamePressed {
                    dismiss()
                } onSuccess: {
                    dismiss()
                    onSuccess()
                }
            }
            .padding(.bottom)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Asset.Colors.darkBackground.swiftUIColor
                .ignoresSafeArea()
        }
        .loadingIndicator(isShowing: $viewModel.showLoading)
        .snackbar(text: viewModel.errorMessage, isShowing: $viewModel.showSnackBar)
        .onChange(of: viewModel.newUsername) { newValue in
            viewModel.saveUsernameDisabled = !newValue.isValidUsername()
        }
    }
}

struct CreateNameScreen_Previews: PreviewProvider {
    static var previews: some View {
        CreateNameScreen(viewModel: AuthenticationViewModel()) { }
    }
}
