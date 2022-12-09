import Combine
import Factory
import Foundation
import GoogleSignIn

enum AuthenticationType {
    case register, login
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Injected(Container.authenticationService) var authenticationService
    @Injected(Container.userService) var userService

    @Published var authenticationType: AuthenticationType = .register

    @Published var registerEmail = String.empty
    @Published var registerUsername = String.empty
    @Published var registerPassword = String.empty

    @Published var registerDisabled = true

    @Published var loginEmail = String.empty
    @Published var loginPassword = String.empty

    @Published var loginDisabled = true

    @Published var showOnboarding = false

    @Published var showErrorMessage = false
    @Published var showSnackBar = false
    var errorMessage = String.empty

    @Published var showLoading = false

    @Published var newUsername = String.empty
    @Published var saveUsernameDisabled = true

    private var publishers = Set<AnyCancellable>()

    init() {
        initInputListeners()
    }

    func signIn(onSuccess successNavigationAction: @escaping () -> Void) {
        guard !loginEmail.isEmpty, !loginPassword.isEmpty else { return }

        showLoading = true

        authenticationService.signIn(email: loginEmail, password: loginPassword) { [weak self] _, error in
            guard error == nil else {
                self?.errorMessage = L10n.Authentication.wrongLoginInputs
                self?.showErrorMessage = true
                self?.showLoading = false
                return
            }
            successNavigationAction()
            self?.resetTextFields()
            self?.showLoading = false
        }
    }

    func signUp(onSuccess successNavigationAction: @escaping () -> Void) {
        showLoading = true
        guard !registerEmail.isEmpty, !registerPassword.isEmpty, !registerUsername.isEmpty else {
            errorMessage = L10n.Authentication.invalidCredentials
            showErrorMessage = true
            showLoading = false
            return
        }

        Task {
            do {
                let userNameExists = try await userService.usernameExists(registerUsername)
                if userNameExists {
                    errorMessage = L10n.Authentication.usernameExists
                    showErrorMessage = true
                    showLoading = false
                    return
                }
                authenticationService.signUp(
                    email: registerEmail,
                    password: registerPassword
                ) { [weak self] result, error in
                    guard error == nil,
                        let uid = result?.user.uid,
                        result?.user.email != nil,
                        let username = self?.registerUsername,
                        let self = self else {
                            self?.errorMessage = L10n.Authentication.generalError
                            self?.showErrorMessage = true
                            self?.showLoading = false
                            return
                    }
                    Task {
                        do {
                            try await self.createUser(uid: uid, username: username)
                        } catch {
                            self.authenticationService.deleteSignedInUser { _ in }
                            self.errorMessage = L10n.Authentication.generalError
                            self.showErrorMessage = true
                            self.showLoading = false
                            return
                        }
                    }
                    successNavigationAction()
                    self.authenticationService.setSignedInUserName(
                        name: self.registerUsername
                    ) { _ in }
                    self.resetTextFields()
                    self.showLoading = false
                }
            } catch {
                errorMessage = L10n.Authentication.generalError
                showErrorMessage = true
                showLoading = false
                return
            }
        }
    }

    func googleButtonPressed(onSuccess: @escaping (Bool) -> Void) {
        authenticationService.googleSignIn { firstLogin, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                onSuccess(firstLogin ?? false)
            }
        }
    }

    func saveUsernamePressed(onFailed: @escaping () -> Void, onSuccess: @escaping () -> Void) {
        guard newUsername.isValidUsername() else { return }
        showLoading = true
        authenticationService.setSignedInUserName(name: newUsername) { [weak self] error in
            guard let self = self else {
                return
            }
            guard error == nil,
                  let uid = self.authenticationService.signedInUserUID
            else {
                self.showLoading = false
                self.errorMessage = L10n.Authentication.generalError
                self.showSnackBar = true
                return
            }
            Task {
                do {
                    try await self.createUser(uid: uid, username: self.newUsername)
                    self.showLoading = false
                    onSuccess()
                } catch {
                    self.showLoading = false
                    self.errorMessage = L10n.Authentication.generalError
                    self.showSnackBar = true
                    self.authenticationService.deleteSignedInUser { _ in }
                    onFailed()
                    return
                }
            }
        }
    }

    private func createUser(uid: String, username: String) async throws {
        let user = User(userUID: uid, userName: username)
        try await userService.createUser(user)
    }

    private func resetTextFields() {
        loginEmail = String.empty
        loginPassword = String.empty
        registerEmail = String.empty
        registerPassword = String.empty
        registerUsername = String.empty
    }
}

extension AuthenticationViewModel {
    private var isRegisterDisabledPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3($registerEmail, $registerPassword, $registerUsername)
            .map { email, password, username in
                !(email.isValidEmail() && !password.isEmpty && username.isValidUsername())
            }
            .eraseToAnyPublisher()
    }

    private var isLoginDisabledPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($loginEmail, $loginPassword)
            .map { email, password in
                !(email.isValidEmail() && !password.isEmpty)
            }
            .eraseToAnyPublisher()
    }

    private func initInputListeners() {
        isRegisterDisabledPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.registerDisabled, on: self)
            .store(in: &publishers)
        isLoginDisabledPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.loginDisabled, on: self)
            .store(in: &publishers)
    }
}
