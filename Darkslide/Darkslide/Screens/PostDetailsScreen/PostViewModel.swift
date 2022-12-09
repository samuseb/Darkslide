import Factory
import Foundation

class PostViewModel: ObservableObject {
    private enum Constants {
        static let commentMaxCharacters = 250
        static let pageLimit = 5
    }

    @Injected(Container.postService) var postService
    @Injected(Container.authenticationService) var authenticationService
    @Injected(Container.commentService) var commentService

    var post: Post
    var showEditButton: Bool
    let onDeletePostAction: (Post) -> Void

    var creatorUsername: String?

    @Published var showEditScreen = false

    @Published var comments = [Comment]()
    @Published var commentInput = String.empty
    @Published var showComments = false
    @Published var showTooLongComment = false
    @Published var showDeleteCommentAlert = false

    var selectedComment: Comment?

    var focusCommentTextFieldOnAppear = false
    var currentCommentPage = 1
    var allCommentsFetched = false

    @Published var showSnackBar = false
    var snackBarMessage = String.empty

    init(post: Post, showEditButton: Bool = false, onDeletePostAction: @escaping (Post) -> Void = { _ in }) {
        self.post = post
        self.onDeletePostAction = onDeletePostAction
        self.showEditButton = showEditButton
        fetchNextComments()
        getCreatorUsername()
    }

    func getCreatorUsername() {
        Task {
            do {
                let username = try await postService.getCreatorUsername(userUID: post.userUID)
                DispatchQueue.main.async {
                    self.creatorUsername = username
                }
            } catch {
                DispatchQueue.main.async {
                    self.snackBarMessage = L10n.Profile.couldntLoadData
                    self.showSnackBar = true
                }
            }
        }
    }

    func fetchNextComments() {
        guard !allCommentsFetched else { return }
        Task {
            do {
                let newComments = try await commentService.fetchPostComments(
                    postID: post.id,
                    page: currentCommentPage,
                    limit: Constants.pageLimit
                )
                currentCommentPage += 1
                DispatchQueue.main.async { [weak self] in
                    self?.comments.append(contentsOf: newComments)
                }
                if newComments.count < Constants.pageLimit {
                    allCommentsFetched = true
                }
            } catch {
                snackBarMessage = L10n.General.couldntLoadError
                DispatchQueue.main.async { [weak self] in
                    self?.showSnackBar = true
                }
            }
        }
    }

    func postCommentPressed() {
        guard !commentInput.isEmpty else { return }
        guard commentInput.count <= Constants.commentMaxCharacters else {
            showTooLongComment = true
            return
        }
        showTooLongComment = false
        guard let userUID = authenticationService.signedInUserUID,
              let userName = authenticationService.signedInUserName
        else {
            snackBarMessage = L10n.General.somethingWrongTryAgain
            showSnackBar = true
            return
        }

        let newComment = Comment(
            text: commentInput,
            postID: "\(post.id)",
            userUID: userUID,
            userName: userName,
            timeStamp: Date()
        )
        Task {
            do {
                try await commentService.createComment(newComment)
                DispatchQueue.main.async { [weak self] in
                    if self?.allCommentsFetched ?? false {
                        self?.comments.append(newComment)
                    }
                    self?.commentInput = String.empty
                    self?.snackBarMessage = L10n.Comments.posted
                    self?.showSnackBar = true
                }
            } catch {
                snackBarMessage = L10n.General.somethingWrongTryAgain
                DispatchQueue.main.async { [weak self] in
                    self?.showSnackBar = true
                }
                return
            }
        }
    }

    func deleteSelectedComment() {
        guard let selectedComment = selectedComment else {
            snackBarMessage = L10n.General.somethingWrongTryAgain
            showSnackBar = true
            return
        }
        Task {
            do {
                try await commentService.deleteComment(selectedComment)
                refreshComments()
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.snackBarMessage = L10n.General.somethingWrongTryAgain
                    self?.showSnackBar = true
                }
            }
        }
    }

    func refreshComments() {
        DispatchQueue.main.async { [weak self] in
            self?.comments.removeAll()
            self?.allCommentsFetched = false
            self?.currentCommentPage = 1
            self?.fetchNextComments()
        }
    }
}
