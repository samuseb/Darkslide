import SwiftUI

struct AccountSettingsScreen: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject var viewModel: AccountSettingsViewModel

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink(value: AccountSettingsDestination.bioEdit) {
                        Text(L10n.ProfileSettings.editBio)
                    }
                    .disabled(viewModel.linksDisabled)
                    NavigationLink(value: AccountSettingsDestination.profilePhotoEdit) {
                        Text(L10n.ProfileSettings.editProfilePhoto)
                    }
                    .disabled(viewModel.linksDisabled)
                    NavigationLink(value: AccountSettingsDestination.coverPhotoEdit) {
                        Text(L10n.ProfileSettings.editCoverPhoto)
                    }
                    .disabled(viewModel.linksDisabled)
                }

                NavigationLink(value: AccountSettingsDestination.about) {
                    Text(L10n.ProfileSettings.about)
                }

                Section {
                    Button {
                        viewModel.signOut {
                            appViewModel.signedIn = false
                        }
                    } label: {
                        Text(L10n.ProfileSettings.signOut)
                    }
                    .disabled(viewModel.linksDisabled)
                    Button {
                        viewModel.deleteTapped()
                    } label: {
                        Text(L10n.ProfileSettings.deleteAccount)
                            .foregroundColor(.red)
                    }
                    .disabled(viewModel.linksDisabled)
                }
            }
            .padding(.top)
            .foregroundColor(Asset.Colors.controlTint.swiftUIColor)
            .preferredColorScheme(.dark)
            .scrollContentBackground(.hidden)
            .background {
                Asset.Colors.darkBackground.swiftUIColor
                    .ignoresSafeArea()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .loadingIndicator(isShowing: $viewModel.showLoading)
            .navigationTitle(L10n.ProfileSettings.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: AccountSettingsDestination.self) { value in
                switch value {
                case .bioEdit: BioEditScreen(viewModel: viewModel)
                case .coverPhotoEdit: CoverPhotoEditScreen(viewModel: viewModel)
                case .profilePhotoEdit: ProfilePhotoEditScreen(viewModel: viewModel)
                case .about: OnboardingScreen()
                }
            }
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .foregroundColor(Asset.Colors.controlTint.swiftUIColor)

            }
            .alert(L10n.ProfileSettings.reauthRequestTitle, isPresented: $viewModel.showReAuthenticateAlert, actions: {
                SecureField(L10n.Authentication.password, text: $viewModel.reAuthPassword)
                    .foregroundColor(.blue)

                Button(L10n.General.cancel, role: .cancel) {
                    viewModel.showReAuthenticateAlert = false
                }
                Button {
                    viewModel.reAuthenticate()
                } label: {
                    Text(L10n.General.ok)
                }
            }, message: {
                Text(viewModel.authenticationService.signedInUserEmail ?? String.empty).bold()
            })
            .alert(
                L10n.ProfileSettings.areYouSureDelete,
                isPresented: $viewModel.showAreYouSureAlert
            ) {
                Button(L10n.General.cancel, role: .cancel) {
                    viewModel.showAreYouSureAlert = false
                }
                Button(L10n.General.delete, role: .destructive) {
                    viewModel.deleteAccount {
                        appViewModel.signedIn = false
                    }
                }
            }
            .alert("Your session has expired. Please sign in again.",
                   isPresented: $viewModel.showSessionExpiredAlert
            ) {
                Button(L10n.General.ok) {
                    viewModel.signOut {
                        appViewModel.signedIn = false
                    }
                }
            }
        }
        .snackbar(text: viewModel.errorMessage, isShowing: $viewModel.showSnackBar)
        .accentColor(Asset.Colors.controlTint.swiftUIColor)
        .onAppear {
            viewModel.showErrorIfLoadFailed()
        }
    }
}

struct AccountSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsScreen(viewModel: AccountSettingsViewModel(user: User.mock))
    }
}
