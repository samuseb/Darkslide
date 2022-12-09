import SwiftUI

struct AuthenticationScreen: View {
    private enum Constants {
        static let welcomeFontSize: CGFloat = 40
        static let inputFrameHeight: CGFloat = 280
        static let animationDuration: CGFloat = 0.2
    }
    @EnvironmentObject var appViewModel: AppViewModel

    @StateObject var viewModel: AuthenticationViewModel

    var body: some View {
        VStack {
            Spacer()

            Text(L10n.Authentication.welcome)
                .font(.system(size: Constants.welcomeFontSize, weight: .bold))
                .multilineTextAlignment(.center)
                .defaultText()
                .padding()
            Text(L10n.Authentication.glad)
                .defaultText()

            Picker(L10n.Authentication.authenticationType, selection: $viewModel.authenticationType) {
                Text(L10n.Authentication.register).tag(AuthenticationType.register)
                Text(L10n.Authentication.login).tag(AuthenticationType.login)
            }
            .pickerStyle(.segmented)
            .colorMultiply(Color.white)
            .padding(.horizontal)

            Text(viewModel.errorMessage)
                .foregroundColor(.red)
                .opacity(viewModel.showErrorMessage ? 1 : .zero)

            Group {
                if viewModel.authenticationType == .register {
                    RegisterInputGroup(
                        email: $viewModel.registerEmail,
                        username: $viewModel.registerUsername,
                        password: $viewModel.registerPassword,
                        buttonDisabled: $viewModel.registerDisabled
                    ) {
                        viewModel.signUp {
                            appViewModel.signedIn = true
                        }
                    }
                    .transition(.move(edge: .trailing))
                } else {
                    LoginInputGroup(
                        email: $viewModel.loginEmail,
                        password: $viewModel.loginPassword,
                        buttonDisabled: $viewModel.loginDisabled
                    ) {
                        viewModel.signIn { appViewModel.signedIn = true }
                    }
                    .transition(.move(edge: .leading))
                }
            }
            .frame(height: Constants.inputFrameHeight)
            .animation(.easeIn(duration: Constants.animationDuration), value: viewModel.authenticationType)

            Text(L10n.Authentication.or)
                .foregroundColor(Asset.Colors.controlGray.swiftUIColor)

            GoogleSignInButton {
                viewModel.googleButtonPressed { firstLogin in
                    appViewModel.showUsernameCreationScreen = firstLogin
                    appViewModel.signedIn = !firstLogin
                }
            }
            .padding(.vertical, Layout.padding10)
            .padding(.horizontal, Layout.padding30)

            Button {
                viewModel.showOnboarding = true
            } label: {
                Text(L10n.Authentication.whatisdarkslide)
                    .underline()
                    .defaultText()
            }
            .padding(Layout.padding10)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea()
        .ignoresSafeArea(.keyboard)
        .background(Color(asset: Asset.Colors.darkBackground))
        .onChange(of: viewModel.authenticationType, perform: { _ in
            viewModel.showErrorMessage = false
        })
        .sheet(isPresented: $viewModel.showOnboarding) {
            OnboardingScreen()
        }
        .loadingIndicator(isShowing: $viewModel.showLoading)
    }
}

struct AuthenticationScreen_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationScreen(viewModel: AuthenticationViewModel())
    }
}
