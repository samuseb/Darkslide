import Factory
import Foundation

final class SearchViewModel: ObservableObject {
    @Injected(Container.userService) var userService
    @Injected(Container.postService) var postService

    @Published var profileSearchInput = String.empty

    @Published var cameraSearchInput = String.empty
    @Published var lensSearchInput = String.empty
    @Published var descriptionSearchInput = String.empty
    @Published var filmStockSearchInput = String.empty

    @Published var searchType = SearchType.post

    @Published var posts = [Post]()
    @Published var profiles = [User]()

    var errorMessage = String.empty
    @Published var showSnackBar = false

    var allUsersFetched = false
    var currentProfilePage = 1

    var allPostsFetched = false
    var currentPostPage = 1

    func fetchNextProfiles() async {
        guard !allUsersFetched else { return }
        do {
            let newProfiles = try await userService.searchForUsers(
                searchTerm: profileSearchInput,
                page: currentProfilePage,
                limit: 8
            )
            if newProfiles.isEmpty {
                allUsersFetched = true
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.profiles.append(contentsOf: newProfiles)
            }
            currentProfilePage += 1
        } catch {
            errorMessage = L10n.General.couldntLoadError
            DispatchQueue.main.async {
                self.showSnackBar = true
            }
        }
    }

    func fetchNextPosts() async {
        guard !allPostsFetched else { return }
        do {
            let newPosts = try await postService.search(
                camera: cameraSearchInput.isEmpty ? nil : cameraSearchInput,
                lens: lensSearchInput.isEmpty ? nil : lensSearchInput,
                description: descriptionSearchInput.isEmpty ? nil : descriptionSearchInput,
                filmStock: filmStockSearchInput.isEmpty ? nil : filmStockSearchInput,
                page: currentPostPage,
                limit: 5
            )
            if newPosts.isEmpty {
                allPostsFetched = true
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.posts.append(contentsOf: newPosts)
            }
            currentPostPage += 1
        } catch {
            errorMessage = L10n.General.couldntLoadError
            DispatchQueue.main.async {
                self.showSnackBar = true
            }
        }
    }

    func searchUserSubmitted() async {
        guard !profileSearchInput.isEmpty else { return }
        currentProfilePage = 1
        allUsersFetched = false
        DispatchQueue.main.async { [weak self] in
            self?.profiles.removeAll()
        }
        await fetchNextProfiles()
    }

    func searchPostSubmitted() async {
        if cameraSearchInput.isEmpty &&
            lensSearchInput.isEmpty &&
            descriptionSearchInput.isEmpty &&
            filmStockSearchInput.isEmpty { return }

        currentPostPage = 1
        allPostsFetched = false
        DispatchQueue.main.async { [weak self] in
            self?.posts.removeAll()
        }
        await fetchNextPosts()
    }
}

enum SearchType {
    case post, profile
}
