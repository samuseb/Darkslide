import Factory
import Foundation

@MainActor
final class AccountSettingsViewModel: ObservableObject {
    @Injected(Container.userService) var userService
    @Injected(Container.authenticationService) var authenticationService

    @Published var showLoading = false
    var errorMessage = String.empty
    @Published var showSnackBar = false

    @Published var bioEditText = String.empty

    @Published var showReAuthenticateAlert = false
    @Published var reAuthPassword = String.empty

    @Published var showSessionExpiredAlert = false
    @Published var showAreYouSureAlert = false

    @Published var showPhotoPicker = false

    @Published var selectedCoverPhotoData: Data?
    @Published var showDeleteCoverAlert = false

    @Published var selectedProfilePhotoData: Data?
    @Published var showDeleteProfilePhotoAlert = false

    @Published var linksDisabled = false

    var user: User?

    init(user: User?) {
        guard let user = user else {
            linksDisabled = true
            return
        }
        linksDisabled = false
        self.user = user
        bioEditText = user.bioDescription ?? String.empty
        selectedCoverPhotoData = user.coverPhotoData
        selectedProfilePhotoData = user.profilePhotoData
    }

    func signOut(onSuccess: @escaping () -> Void) {
        showLoading = true
        do {
            try authenticationService.signOut()
        } catch {
            errorMessage = L10n.General.somethingWrongTryAgain
            showSnackBar = true
            showLoading = false
            return
        }
        onSuccess()
        showLoading = false
    }

    func saveBio(onFinished: () -> Void) {
        guard let user = user, !bioEditText.isEmpty, bioEditText != user.bioDescription else { return }
        showLoading = true
        let oldBio = user.bioDescription
        user.bioDescription = bioEditText
        Task {
            do {
                try await userService.updateUser(user)
                showLoading = false
            } catch {
                showLoading = false
                self.errorMessage = L10n.General.somethingWrongTryAgain
                showSnackBar = true
                user.bioDescription = oldBio
                bioEditText = oldBio ?? String.empty
            }
        }
        onFinished()
    }

    func saveCoverPhoto(onFinished: () -> Void) {
        guard let user = user, let photoData = selectedCoverPhotoData else { return }
        showLoading = true
        let oldPhoto = user.coverPhotoData
        user.coverPhotoData = photoData
        Task {
            do {
                try await userService.updateUser(user)
                showLoading = false
            } catch {
                self.errorMessage = L10n.General.somethingWrongTryAgain
                showSnackBar = true
                user.coverPhotoData = oldPhoto
                selectedCoverPhotoData = oldPhoto
            }
        }
        onFinished()
    }

    func deleteCoverPhoto(onFinished: () -> Void) {
        guard let user = user, user.coverPhotoData != nil else { return }
        showLoading = true
        let oldPhoto = user.coverPhotoData
        user.coverPhotoData = nil
        Task {
            do {
                try await userService.updateUser(user)
                showLoading = false
            } catch {
                self.errorMessage = L10n.CoverEdit.couldntDelete
                showSnackBar = true
                user.coverPhotoData = oldPhoto
                selectedCoverPhotoData = oldPhoto
            }
        }
        onFinished()
    }

    func deleteTapped() {
        guard authenticationService.isSignedIn, authenticationService.signedInUserEmail != nil else {
            errorMessage = L10n.General.somethingWrongTryAgain
            showSnackBar = true
            return
        }
        if authenticationService.signedInAuthenticationMethod == .email {
            showReAuthenticateAlert = true
        } else if authenticationService.signedInAuthenticationMethod == .google {
            authenticationService.reauthenticateWithGoogle { [weak self] error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        self?.showSessionExpiredAlert = true
                    }
                    return
                }
                self?.showAreYouSureAlert = true
            }
        }
    }

    func saveProfilePhoto(onFinished: () -> Void) {
        guard let user = user, let photoData = selectedProfilePhotoData else { return }
        showLoading = true
        let oldProfilePhoto = user.profilePhotoData
        user.profilePhotoData = photoData
        Task {
            do {
                try await userService.updateUser(user)
                showLoading = false
            } catch {
                self.errorMessage = L10n.General.somethingWrongTryAgain
                showSnackBar = true
                user.coverPhotoData = oldProfilePhoto
                selectedCoverPhotoData = oldProfilePhoto
                return
            }
        }
        onFinished()
    }

    func deleteProfilePhoto(onFinished: () -> Void) {
        guard let user = user, user.profilePhotoData != nil else { return }
        showLoading = true
        let oldPhoto = user.profilePhotoData
        user.profilePhotoData = nil
        Task {
            do {
                try await userService.updateUser(user)
                showLoading = false
            } catch {
                self.errorMessage = L10n.ProfilePhotoEdit.couldntDelete
                showSnackBar = true
                user.profilePhotoData = oldPhoto
                selectedProfilePhotoData = oldPhoto
            }
        }
        onFinished()
    }

    func deleteAccount(onSuccess: @escaping () -> Void) {
        guard let user = user,
              let signedInUID = authenticationService.signedInUserUID,
              signedInUID == user.userUID else {
            errorMessage = L10n.General.somethingWrongTryAgain
            showSnackBar = true
            return
        }
        showLoading = true
        authenticationService.deleteSignedInUser { error in
            guard error == nil else {
                self.errorMessage = L10n.General.somethingWrongTryAgain
                self.showSnackBar = true
                self.showLoading = false
                return
            }
            Task {
                do {
                    try await self.userService.deleteUserData(user)
                }
            }
            self.showLoading = false
            onSuccess()
        }
    }

    func reAuthenticate() {
        guard !reAuthPassword.isEmpty, let email = authenticationService.signedInUserEmail else {
            return
        }
        authenticationService.reauthenticate(email: email, password: reAuthPassword) { error in
            guard error == nil else {
                self.errorMessage = L10n.General.somethingWrongTryAgain
                self.showSnackBar = true
                self.reAuthPassword = String.empty
                return
            }
            self.showAreYouSureAlert = true
        }
        reAuthPassword = String.empty
    }

    func showErrorIfLoadFailed() {
        if linksDisabled {
            errorMessage = L10n.General.somethingWrongTryAgain
            showSnackBar = true
        }
    }
}
