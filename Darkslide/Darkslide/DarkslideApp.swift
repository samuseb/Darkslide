import Firebase
import GoogleSignIn
import SwiftUI

@main
struct DarkslideApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init() {
        setAppereanceDefaults()
    }

    private func setAppereanceDefaults() {
        setSegmentedControlAppereanceDefaults()
        setBottomNavBarAppereanceDefaults()
    }

    private func setSegmentedControlAppereanceDefaults() {
        UISegmentedControl.appearance().selectedSegmentTintColor = Asset.Colors.lightGray.color
        UISegmentedControl.appearance().backgroundColor = Asset.Colors.controlGray.color
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }

    private func setBottomNavBarAppereanceDefaults() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        UITabBar.appearance().barTintColor = UIColor(asset: Asset.Colors.darkBackground)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()

        return true
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}
