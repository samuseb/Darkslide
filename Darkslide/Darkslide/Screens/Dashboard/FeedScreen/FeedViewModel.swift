import Factory
import Foundation
import SwiftUI

class FeedViewModel: ObservableObject {
    @Injected(Container.authenticationService) var authenticationService
    @Injected(Container.postService) var postService

    @Published var posts = [Post]()
    @Published var showSnackBar = false
    var errorMessage = String.empty
    @Published var showLoading = false

    var currentPage = 1

    var allPostsFetched = false

    init() {
        showLoading = true
        Task {
            await fetchNextPosts()
            DispatchQueue.main.async {
                self.showLoading = false
            }
        }
    }

    func fetchNextPosts() async {
        guard !allPostsFetched else { return }

        guard let userUID = authenticationService.signedInUserUID else {
            errorMessage = L10n.General.couldntLoadError
            showSnackBar = true
            return
        }
        do {
            let newPosts = try await postService.fetchFeedPosts(userUID: userUID, page: currentPage, limit: 8)
            currentPage += 1
            if newPosts.isEmpty {
                allPostsFetched = true
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.posts.append(contentsOf: newPosts)
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.showSnackBar = true
            }
        }
    }

    func refresh() {
        posts.removeAll()
        allPostsFetched = false
        currentPage = 1
        Task {
            await fetchNextPosts()
        }
    }
}
