import Factory
import Foundation

final class FeedItemCardViewModel: ObservableObject {
    @Injected(Container.postService) var postService

    var post: Post

    @Published var username: String?

    init(post: Post) {
        self.post = post
    }

    func loadUsername() async {
        do {
            username = try await postService.getCreatorUsername(userUID: post.userUID)
        } catch { return }
    }
}
