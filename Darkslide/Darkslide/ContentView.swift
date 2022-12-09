import Factory
import SwiftUI

struct ContentView: View {
    @StateObject var appViewModel = AppViewModel(authenticationService: Container.authenticationService())
    private let authenticationViewModel = AuthenticationViewModel()

    var body: some View {
        ZStack {
            if appViewModel.signedIn {
                DashboardContainerView()
            } else {
                AuthenticationScreen(
                    viewModel: authenticationViewModel
                )
            }
        }
        .environmentObject(appViewModel)
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $appViewModel.showUsernameCreationScreen) {
            CreateNameScreen(viewModel: authenticationViewModel) {
                appViewModel.signedIn = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
