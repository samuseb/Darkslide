import SwiftUI

struct AccountScreen: View {
    private enum Constants {
        static let gridItemMinWidth: CGFloat = 170
        static let gridItemMaxWidth: CGFloat = 180
        static let placeholderRectangleHeight: CGFloat = 150
        static let infoSpacing: CGFloat = 100
        static let cornerRadius: CGFloat = 8
        static let bottomCardOffset: CGFloat = -20
        static let gridSpacing: CGFloat = 10
        static let iconSize: CGFloat = 20
        static let imageTopPadding: CGFloat = 40
    }
    @EnvironmentObject var appViewModel: AppViewModel

    @StateObject var viewModel: AccountViewModel = AccountViewModel()

    var body: some View {
        UserDetailsScrollView(
            user: $viewModel.user,
            posts: $viewModel.posts,
            postCount: $viewModel.postCount,
            followerCount: $viewModel.followerCount
        ) {
            viewModel.fetchNextPosts()
        }
        .overlay {
            VStack {
                HStack {
                    if let profilePhoto = viewModel.user?.profilePhotoData {
                        Image(uiImage: UIImage(data: profilePhoto) ?? UIImage())
                            .resizable()
                            .frame(width: 65, height: 65)
                            .clipShape(Circle())
                    }

                    Text(viewModel.user?.userName ?? String.empty)
                        .defaultText()
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    HStack {
                        Button {
                            viewModel.showCreatePostView = true
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: Constants.iconSize, height: Constants.iconSize)
                                .padding(.horizontal, Layout.padding10)
                        }

                        Button {
                            viewModel.showSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: Constants.iconSize, height: Constants.iconSize)
                                .padding(.horizontal, Layout.padding10)
                        }
                    }
                }
                .padding()
                .background(.thinMaterial)
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .navigationDestination(for: Post.self, destination: { post in
            PostDetailsScreen(viewModel: PostViewModel(post: post, showEditButton: true) { post in
                viewModel.removePostFromArray(post: post)
            })
        })
        .navigationDestination(for: HashableUserUID.self) { userUID in
            ProfileScreen(userUID: userUID.uid)
        }
        .sheet(isPresented: $viewModel.showCreatePostView) {
            CreatePostPage(
                viewModel: CreatePostViewModel { post in
                    viewModel.posts.insert(post, at: 0)
                    viewModel.postCount? += 1
                }
            )
        }
        .fullScreenCover(isPresented: $viewModel.showSettings) {
            AccountSettingsScreen(viewModel: AccountSettingsViewModel(user: viewModel.user))
        }
        .snackbar(text: viewModel.errorMessage, isShowing: $viewModel.showSnackBar)
    }
}

struct AccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        AccountScreen(viewModel: AccountViewModel())
    }
}
