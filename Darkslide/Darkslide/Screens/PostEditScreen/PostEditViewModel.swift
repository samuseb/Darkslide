import Factory
import Foundation

class PostEditViewModel: ObservableObject {
    @Injected(Container.postService) var postService

    var post: Post

    @Published var description: String
    @Published var digital: Bool
    @Published var filmStock: String
    @Published var camera: String
    @Published var lens: String
    @Published var shutterSpeed: ShutterSpeed?
    @Published var aperture: Aperture?
    @Published var iso: Int?

    @Published var showDeleteAlert: Bool = false
    @Published var showLoading = false

    @Published var showSnackBar = false
    var errorMessage = String.empty
    let removeFromListOnDeleteAction: (Post) -> Void

    init(post: Post, removeFromListOnDeleteAction: @escaping (Post) -> Void = { _ in }) {
        self.post = post
        self.removeFromListOnDeleteAction = removeFromListOnDeleteAction

        self.description = post.description ?? String.empty
        self.digital = post.digital
        self.filmStock = post.filmStock ?? String.empty
        self.camera = post.camera ?? String.empty
        self.lens = post.lens ?? String.empty
        self.shutterSpeed = post.shutterSpeed
        self.aperture = post.aperture
        self.iso = post.iso
    }

    func updatePost() async {
        post.description = self.description
        post.digital = self.digital
        post.filmStock = digital ? nil : (self.filmStock.isEmpty ? nil : self.filmStock)
        post.camera = self.camera.isEmpty ? nil : self.camera
        post.lens = self.lens.isEmpty ? nil : self.lens
        post.shutterSpeed = self.shutterSpeed
        post.aperture = self.aperture
        post.iso = self.iso

        do {
            try await postService.updatePost(post)
        } catch {
            errorMessage = L10n.Post.couldntUpdateError
            showSnackBar = true
        }
    }

    func deletePost(onSuccess: @escaping () -> Void) async {
        DispatchQueue.main.async {
            self.showLoading = true
        }
        do {
            try await postService.deletePost(post)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showDeleteAlert = false
                self.showLoading = false
                self.removeFromListOnDeleteAction(self.post)
                onSuccess()
            }
        } catch {
            DispatchQueue.main.async {
                self.showDeleteAlert = false
                self.showLoading = false
            }
            errorMessage = L10n.Post.couldntDeleteError
            showSnackBar = true
        }
    }
}
