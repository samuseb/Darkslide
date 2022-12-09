import SwiftUI

struct SearchScreen: View {
    private enum Constants {
        static let textFieldHeight = 40.0
        static let animationDuration = 0.2
    }
    @StateObject var viewModel = SearchViewModel()

    var body: some View {
        ScrollView {
            Picker("Search Type", selection: $viewModel.searchType) {
                Text(L10n.Search.posts).tag(SearchType.post)
                Text(L10n.Search.profiles).tag(SearchType.profile)
            }
            .pickerStyle(.segmented)
            .colorMultiply(Color.white)
            .padding(Layout.padding10)

            Group {
                if viewModel.searchType == .profile {
                    DSTextField(
                        placeHolder: L10n.Search.placeholder,
                        text: $viewModel.profileSearchInput,
                        height: Constants.textFieldHeight
                    )
                    .padding(Layout.padding10)
                    .padding(.bottom)
                    .onSubmit {
                        Task {
                            await viewModel.searchUserSubmitted()
                        }
                    }
                    .transition(.move(edge: .trailing))
                } else if viewModel.searchType == .post {
                    Group {
                        HStack {
                            DSTextField(
                                placeHolder: L10n.Search.camera,
                                text: $viewModel.cameraSearchInput,
                                height: Constants.textFieldHeight
                            )
                            DSTextField(
                                placeHolder: L10n.Search.lens,
                                text: $viewModel.lensSearchInput,
                                height: Constants.textFieldHeight
                            )
                        }
                        HStack {
                            DSTextField(
                                placeHolder: L10n.Search.filmStock,
                                text: $viewModel.filmStockSearchInput,
                                height: Constants.textFieldHeight
                            )
                            DSTextField(
                                placeHolder: L10n.Search.inDescription,
                                text: $viewModel.descriptionSearchInput,
                                height: Constants.textFieldHeight
                            )
                        }
                    }
                    .transition(.move(edge: .leading))
                    .padding(Layout.padding5)
                    .onSubmit {
                        Task {
                            await viewModel.searchPostSubmitted()
                        }
                    }
                }
            }
            .animation(.easeIn(duration: Constants.animationDuration), value: viewModel.searchType)

            LazyVStack {
                if viewModel.searchType == .profile {
                    ForEach(viewModel.profiles.indices, id: \.self) { index in
                        NavigationLink(value: viewModel.profiles[index]) {
                            ProfileListCard(user: viewModel.profiles[index])
                                .padding(.horizontal, Layout.padding10)
                                .padding(.vertical, Layout.padding4)
                                .onAppear {
                                    if index == viewModel.profiles.count - 2 {
                                        Task {
                                            await viewModel.fetchNextProfiles()
                                        }
                                    }
                                }
                        }
                        .transition(.move(edge: .trailing))
                    }
                } else if viewModel.searchType == .post {
                    ForEach(viewModel.posts.indices, id: \.self) { index in
                        NavigationLink(value: viewModel.posts[index]) {
                            PostListCard(post: viewModel.posts[index])
                                .padding(.horizontal, Layout.padding10)
                                .padding(.vertical, Layout.padding4)
                                .onAppear {
                                    if index == viewModel.posts.count - 2 {
                                        Task {
                                            await viewModel.fetchNextPosts()
                                        }
                                    }
                                }
                        }
                    }
                    .transition(.move(edge: .leading))
                }
            }
            Spacer()
        }
        .background(Color(asset: Asset.Colors.darkBackground))
        .animation(.easeIn(duration: Constants.animationDuration), value: viewModel.searchType)
        .navigationTitle(L10n.Search.title)
        .snackbar(text: viewModel.errorMessage, isShowing: $viewModel.showSnackBar)
        .navigationDestination(for: User.self) { user in
            ProfileScreen(user: user)
        }
        .navigationDestination(for: HashableUserUID.self) { userUID in
            ProfileScreen(userUID: userUID.uid)
        }
        .navigationDestination(for: Post.self) { post in
            PostDetailsScreen(viewModel: PostViewModel(post: post))
        }
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen(viewModel: SearchViewModel())
    }
}
