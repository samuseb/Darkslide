import Foundation

protocol CommentService {
    func fetchPostComments(postID: UUID, page: Int, limit: Int) async throws -> [Comment]
    func createComment(_ comment: Comment) async throws
    func updateComment(_ comment: Comment) async throws
    func deleteComment(_ comment: Comment) async throws
}

final class VaporCommentService: CommentService {
    private enum Constants {
        static let commentsURL = "http://127.0.0.1:8080/comments"
    }

    func fetchPostComments(postID: UUID, page: Int, limit: Int) async throws -> [Comment] {
        guard let url = URL(string: Constants.commentsURL + "/\(postID)?page=\(page)&limit=\(limit)") else {
            throw HttpError.badURL
        }

        return try await HttpClient.shared.fetch(url: url)
    }

    func createComment(_ comment: Comment) async throws {
        guard let url = URL(string: Constants.commentsURL) else {
            throw HttpError.badURL
        }

        try await HttpClient.shared.sendData(to: url, object: comment, httpMethod: "POST")
    }

    func updateComment(_ comment: Comment) async throws {
        guard let url = URL(string: Constants.commentsURL) else {
            throw HttpError.badURL
        }

        try await HttpClient.shared.sendData(to: url, object: comment, httpMethod: "PUT")
    }

    func deleteComment(_ comment: Comment) async throws {
        guard let url = URL(string: Constants.commentsURL + "/\(comment.id)") else {
            throw HttpError.badURL
        }
        try await HttpClient.shared.delete(url: url)
    }
}
