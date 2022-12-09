import SwiftUI

struct DashboardContainerView: View {

    var body: some View {
        TabView {
            NavigationStack {
                FeedScreen()
            }
            .tabItem {
                Image(systemName: "house.fill")
                    .renderingMode(.template)
            }

            NavigationStack {
                SearchScreen()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                    .renderingMode(.template)
            }

            NavigationStack {
                AccountScreen()
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                    .renderingMode(.template)
            }
        }
        .accentColor(Color(asset: Asset.Colors.controlTint))
    }
}

struct DashboardContainerView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardContainerView()
    }
}
