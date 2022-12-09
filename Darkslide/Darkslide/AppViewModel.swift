import Factory
import Foundation

class AppViewModel: ObservableObject {
    let authenticationService: AuthenticationService

    @Published var signedIn: Bool
    @Published var showUsernameCreationScreen = false

    init(authenticationService: AuthenticationService) {
        self.signedIn = authenticationService.isSignedIn
        self.authenticationService = authenticationService
    }
}
