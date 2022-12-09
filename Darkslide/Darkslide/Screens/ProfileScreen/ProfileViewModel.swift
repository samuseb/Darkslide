import Factory
import Foundation

@MainActor
final class ProfileViewModel: UserDetailsViewModelBase {
    @Injected(Container.authenticationService) var authenticationService
    @Injected(Container.followService) var followService

    @Published var followToggle = false

    @Published var loadFailed = false

    init(user: User) {
        super.init()
        self.user = user
        loadData()
        Task {
            guard let loggedInUID = authenticationService.signedInUserUID else {
                return
            }
            self.followToggle = try await followService.followExists(
                followerUID: loggedInUID,
                followedUID: user.userUID
            )
        }
    }

    init(userUID: String) {
        super.init()
        Task {
            do {
                let user = try await userService.getUserByUID(userUID)
                self.user = user
            } catch {
                loadFailed = true
            }
            getCountData()
            guard let user = user else { return }
            do {
                posts = try await postService.fetchUserPosts(userUID: user.userUID, page: 1, limit: 8)
            } catch {
                self.errorMessage = L10n.General.couldntLoadError
                self.showSnackBar = true
                return
            }

        }
    }

    func loadData() {
        guard !dataAlreadyLoaded else { return }
        guard let user = user else {
            self.errorMessage = L10n.General.couldntLoadError
            self.showSnackBar = true
            return
        }
        getCountData()
        Task {
            do {
                posts = try await postService.fetchUserPosts(userUID: user.userUID, page: 1, limit: 8)
            } catch {
                self.errorMessage = L10n.General.couldntLoadError
                self.showSnackBar = true
                return
            }
        }
        dataAlreadyLoaded = true
    }

    func follow() {
        guard let authenticatedUID = authenticationService.signedInUserUID, let userUID = user?.userUID else {
            errorMessage = L10n.General.somethingWrongTryAgain
            showSnackBar = true
            followToggle = false
            return
        }
        Task {
            do {
                try await followService.createFollowing(followerUID: authenticatedUID, followedUID: userUID)
                followerCount? += 1
            } catch {
                self.errorMessage = L10n.General.somethingWrongTryAgain
                self.showSnackBar = true
                self.followToggle = false
            }
        }
    }

    func unfollow() {
        print("unfollow called")
        guard let authenticatedUID = authenticationService.signedInUserUID, let userUID = user?.userUID else {
            errorMessage = L10n.General.somethingWrongTryAgain
            showSnackBar = true
            return
        }
        Task {
            do {
                try await followService.deleteFollowing(followerUID: authenticatedUID, followedUID: userUID)
                followerCount? -= 1
            } catch {
                errorMessage = L10n.General.somethingWrongTryAgain
                showSnackBar = true
            }
        }
    }
}
