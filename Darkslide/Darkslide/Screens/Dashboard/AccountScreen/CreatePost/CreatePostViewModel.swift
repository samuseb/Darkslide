import Combine
import Factory
import Foundation
import _PhotosUI_SwiftUI

@MainActor
final class CreatePostViewModel: ObservableObject {
    @Injected(Container.postService) var postService
    @Injected(Container.authenticationService) var authenticationService

    var updateProfileAfterShare: (Post) -> Void

    @Published var shareDisabled = false

    @Published var selectedPhotoData: Data?

    @Published var description = String.empty
    @Published var digital = false
    @Published var camera = String.empty
    @Published var lens = String.empty
    @Published var shutterSpeed: ShutterSpeed?
    @Published var aperture: Aperture?
    @Published var iso: Int?
    @Published var filmStock = String.empty

    @Published var showError = false

    @Published var showPhotoPicker = false

    init(updateProfileAfterShare: @escaping (Post) -> Void) {
        self.updateProfileAfterShare = updateProfileAfterShare
    }

    func sharePost(onSuccess: @escaping () -> Void) async {
        guard let signedInUserUID = authenticationService.signedInUserUID else {
            showError = true
            return
        }
        guard let selectedPhotoData = selectedPhotoData else { return }

        let post = Post(
            userUID: signedInUserUID,
            description: self.description.isEmpty ? nil : self.description,
            digital: self.digital,
            filmStock: self.digital ? nil : (self.filmStock.isEmpty ? nil : self.filmStock),
            camera: self.camera.isEmpty ? nil : self.camera,
            lens: self.lens.isEmpty ? nil : self.lens,
            shutterSpeed: self.shutterSpeed,
            aperture: self.aperture,
            iso: self.iso,
            imageData: selectedPhotoData,
            timeStamp: Date()
        )

        do {
            try await postService.sharePost(post)
            updateProfileAfterShare(post)
        } catch {
            showError = true
        }
        onSuccess()
    }

}
