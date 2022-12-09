import Combine
import Factory
import Foundation

@MainActor
class UserDetailsViewModelBase: ObservableObject {
    @Injected(Container.postService) var postService
    @Injected(Container.userService) var userService

    @Published var posts = [Post]()
    @Published var postCount: Int?
    @Published var followerCount: Int?

    var errorMessage = String.empty
    @Published var showSnackBar = false

    @Published var showLoading = false
    @Published var showPostsLoading = false

    var user: User?

    var currentPostPage = 3
    var allPostsFetched = false
    var dataAlreadyLoaded = false

    func fetchNextPosts() {
        guard let user = user else { return }
        guard !allPostsFetched else { return }
        showPostsLoading = true
        Task { [weak self] in
            do {
                let newPosts = try await postService.fetchUserPosts(
                    userUID: user.userUID,
                    page: self?.currentPostPage,
                    limit: 4
                )
                if newPosts.isEmpty {
                    self?.allPostsFetched = true
                } else {
                    self?.currentPostPage += 1
                    self?.posts.append(contentsOf: newPosts)
                }
            } catch {
                self?.errorMessage = L10n.General.couldntLoadError
                self?.showSnackBar = true
            }
        }
        showPostsLoading = false
    }

    func getCountData() {
        guard let user = user else {
            return
        }
        Task { [weak self] in
            do {
                self?.postCount = try await userService.getUserPostCount(user)
                self?.followerCount = try await userService.getUserFollowerCount(user)
            } catch {
                errorMessage = L10n.General.couldntLoadError
                showSnackBar = true
                return
            }
        }
    }
}

@MainActor
final class AccountViewModel: UserDetailsViewModelBase {
    @Injected(Container.authenticationService) var authenticationService

    @Published var showCreatePostView = false

    @Published var showSettings = false

    override init() {
        super.init()
        loadData()
    }

    func loadData() {
        guard !dataAlreadyLoaded else { return }
        guard let userUID = authenticationService.signedInUserUID else {
            self.errorMessage = L10n.General.couldntLoadError
            self.showSnackBar = true
            return
        }
        Task {
            do {
                self.user = try await userService.getUserByUID(userUID)
                self.getCountData()
            } catch {
                self.errorMessage = L10n.General.couldntLoadError
                self.showSnackBar = true
                return
            }
        }

        Task {
            do {
                posts = try await postService.fetchUserPosts(userUID: userUID, page: 1, limit: 8)
            } catch {
                self.errorMessage = L10n.General.couldntLoadError
                self.showSnackBar = true
                return
            }
        }
        dataAlreadyLoaded = true
        if authenticationService.signedInUserName == nil, let userName = user?.userName {
            authenticationService.setSignedInUserName(name: userName) { error in
                if error != nil {
                    self.errorMessage = L10n.General.somethingWrongTryAgain
                    self.showSnackBar = true
                }
            }
        }
    }

    func removePostFromArray(post: Post) {
        posts.removeAll { currentPost in
            currentPost.id == post.id
        }
    }
}
