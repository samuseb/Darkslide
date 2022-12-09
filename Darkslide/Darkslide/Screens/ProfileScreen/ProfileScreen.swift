import SwiftUI

struct ProfileScreen: View {
    @StateObject var viewModel: ProfileViewModel

    init(user: User) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    init(userUID: String) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(userUID: userUID))
    }

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
                    if viewModel.authenticationService.signedInUserUID != viewModel.user?.userUID {
                        VStack {
                            FollowButton(isOn: $viewModel.followToggle) {
                                withAnimation {
                                    viewModel.followToggle.toggle()
                                }
                                viewModel.followToggle ? viewModel.follow() : viewModel.unfollow()
                            }
                        }
                    }
                }
                .padding()
                .background(.thinMaterial)
                Spacer()
            }
        }
        .snackbar(text: viewModel.errorMessage, isShowing: $viewModel.showSnackBar)
        .overlay {
            if viewModel.loadFailed {
                VStack {
                    Text(L10n.General.somethingWrongAlert)
                        .defaultText()
                    Text(L10n.Profile.couldntLoadData)
                        .defaultText()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Asset.Colors.darkBackground.swiftUIColor
                        .ignoresSafeArea()
                }
            }
        }
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(user: User.mock)
    }
}
