import SwiftUI

struct FeedScreen: View {
    @StateObject var viewModel = FeedViewModel()

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.posts.indices, id: \.self) { postIndex in
                    NavigationLink(value: viewModel.posts[postIndex]) {
                        FeedItemCard(
                            viewModel: .init(post: viewModel.posts[postIndex])
                        )
                        .onAppear {
                            if postIndex == viewModel.posts.count - 2 {
                                Task {
                                    await viewModel.fetchNextPosts()
                                }
                            }
                        }
                    }
                }
                Spacer()
                if viewModel.posts.isEmpty {
                    Text(L10n.Feed.youShouldFollow)
                        .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                        .padding()
                } else {
                    Text(L10n.Feed.bottomOfFeed)
                        .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                        .padding()
                }
            }
        }
        .refreshable {
            viewModel.refresh()
        }
        .navigationDestination(for: Post.self) { post in
            PostDetailsScreen(
                viewModel: PostViewModel(
                    post: post
                )
            )
        }
        .navigationDestination(for: HashableUserUID.self) { userUID in
            ProfileScreen(userUID: userUID.uid)
        }
        .loadingIndicator(isShowing: $viewModel.showLoading)
        .snackbar(text: viewModel.errorMessage, isShowing: $viewModel.showSnackBar)
        .background(Color(asset: Asset.Colors.darkBackground))
        .navigationTitle(L10n.Feed.title)
    }
}

struct FeedScreen_Previews: PreviewProvider {
    static var previews: some View {
        FeedScreen()
    }
}
