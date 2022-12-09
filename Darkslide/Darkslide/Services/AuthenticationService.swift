import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn

protocol AuthenticationService {
    var isSignedIn: Bool { get }
    var signedInUserEmail: String? { get }
    var signedInUserName: String? { get }
    var signedInUserUID: String? { get }
    var signedInAuthenticationMethod: AuthenticationMethod? { get }

    func signIn(email: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?) -> Void)
    func googleSignIn(completionHandler: @escaping (Bool?, Error?) -> Void)
    func signUp(email: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?) -> Void)
    func signOut() throws
    func reauthenticate(email: String, password: String, completionHandler: @escaping (Error?) -> Void)
    func reauthenticateWithGoogle(completionHander: @escaping (Error?) -> Void)

    func setSignedInUserName(name: String, completionHandler: @escaping (Error?) -> Void)

    func deleteSignedInUser(completionHandler: @escaping (Error?) -> Void)
}

final class FireBaseAuthenticationService: AuthenticationService {

    private let auth = Auth.auth()

    var isSignedIn: Bool {
        auth.currentUser != nil
    }

    var signedInUserEmail: String? {
        auth.currentUser?.email
    }

    var signedInUserName: String? {
        auth.currentUser?.displayName
    }

    var signedInUserUID: String? {
        auth.currentUser?.uid
    }

    var signedInAuthenticationMethod: AuthenticationMethod? {
        if let providerData = auth.currentUser?.providerData {
            for data in providerData {
                if data.providerID == "google.com" {
                    return .google
                } else if data.providerID == "password" {
                    return .email
                }
            }
        }
        return nil
    }

    func signIn(email: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            completionHandler(result, error)
        }
    }

    func googleSignIn(completionHandler: @escaping (Bool?, Error?) -> Void) {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                self.firebaseSignInWithGoogle(for: user, with: error) { firstLogin, error in
                    completionHandler(firstLogin, error)
                }
            }
        } else {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }

            let configuration = GIDConfiguration(clientID: clientID)

            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }

            GIDSignIn.sharedInstance.signIn(
                with: configuration,
                presenting: rootViewController
            ) { [unowned self] user, error in
                self.firebaseSignInWithGoogle(for: user, with: error) { firstLogin, error in
                    completionHandler(firstLogin, error)
                }
            }
        }
    }

    private func firebaseSignInWithGoogle(
        for user: GIDGoogleUser?,
        with error: Error?,
        completionHandler: @escaping (Bool?, Error?) -> Void
    ) {
        if let error = error {
            completionHandler(nil, error)
            return
        }

        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else {
                completionHandler(result?.additionalUserInfo?.isNewUser, nil)
            }
        }
    }

    func signUp(email: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            completionHandler(result, error)
        }
    }

    func signOut() throws {
        GIDSignIn.sharedInstance.signOut()
        try auth.signOut()
    }

    func setSignedInUserName(name: String, completionHandler: @escaping (Error?) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
            completionHandler(error)
        }
    }

    func deleteSignedInUser(completionHandler: @escaping (Error?) -> Void) {
        guard let currentUser = auth.currentUser else {
            completionHandler(AuthenticationError.authenticationFailed)
            return
        }
        currentUser.delete { error in
            completionHandler(error)
        }
    }

    func reauthenticateWithGoogle(completionHander: @escaping (Error?) -> Void) {
        guard let credential = googleCredential(), let currentUser = auth.currentUser else {
            completionHander(AuthenticationError.authenticationFailed)
            return
        }
        currentUser.reauthenticate(with: credential) { _, error in
            completionHander(error)
        }
    }

    private func googleCredential() -> AuthCredential? {
        guard let user = GIDSignIn.sharedInstance.currentUser else {return nil}
        guard let idToken = user.authentication.idToken else { return nil}
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: user.authentication.accessToken
        )
        return credential
    }

    func reauthenticate(email: String, password: String, completionHandler: @escaping (Error?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        auth.currentUser?.reauthenticate(with: credential) { _, error in
            completionHandler(error)
        }
    }
}

enum AuthenticationError: Error {
    case authenticationFailed
}

enum UserCreationError: Error {
    case userCreationFailed
}

enum AuthenticationMethod {
    case email, google
}
