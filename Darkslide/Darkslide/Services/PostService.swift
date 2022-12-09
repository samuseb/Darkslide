import Foundation

protocol PostService {
    func fetchFeedPosts(userUID: String, page: Int, limit: Int) async throws -> [Post]
    func fetchUserPosts(userUID: String, page: Int?, limit: Int?) async throws -> [Post]
    func sharePost(_ post: Post) async throws
    func updatePost(_ post: Post) async throws
    func deletePost(_ post: Post) async throws
    func search(
        camera: String?,
        lens: String?,
        description: String?,
        filmStock: String?,
        page: Int?,
        limit: Int?
    ) async throws -> [Post]
    func getCreatorUsername(userUID: String) async throws -> String
}

final class VaporPostSerice: PostService {
    private enum Constants {
        static let postsURL = "http://127.0.0.1:8080/posts"
        static let usersURL = "http://127.0.0.1:8080/users"
    }

    func fetchFeedPosts(userUID: String, page: Int, limit: Int) async throws -> [Post] {
        guard let url = URL(
            string: Constants.postsURL + "/\(userUID)/feed?page=\(page)&limit=\(limit)"
        ) else {
            throw HttpError.badURL
        }

        let postResponse: [Post] = try await HttpClient.shared.fetch(url: url)
        return postResponse
    }

    func fetchUserPosts(userUID: String, page: Int? = nil, limit: Int? = nil) async throws -> [Post] {
        var urlString = Constants.postsURL + "/\(userUID)"
        if let page = page, let limit = limit {
            urlString += "?page=\(page)&limit=\(limit)"
        }
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }

        let postResponse: [Post] = try await HttpClient.shared.fetch(url: url)
        return postResponse
    }

    func sharePost(_ post: Post) async throws {
        guard let url = URL(string: Constants.postsURL) else {
            throw HttpError.badURL
        }

        try await HttpClient.shared.sendData(to: url, object: post, httpMethod: "POST")
    }

    func updatePost(_ post: Post) async throws {
        guard let url = URL(string: Constants.postsURL) else {
            throw HttpError.badURL
        }
        try await HttpClient.shared.sendData(to: url, object: post, httpMethod: "PUT")
    }

    func deletePost(_ post: Post) async throws {
        guard let url = URL(string: Constants.postsURL + "/\(post.id)") else {
            throw HttpError.badURL
        }
        try await HttpClient.shared.delete(url: url)
    }

    func search(
        camera: String? = nil,
        lens: String? = nil,
        description: String? = nil,
        filmStock: String? = nil,
        page: Int? = nil,
        limit: Int? = nil
    ) async throws -> [Post] {
        var urlString = Constants.postsURL + "/search?"
        if let camera = camera { urlString += "camera=\(camera)&"}
        if let lens = lens { urlString += "lens=\(lens)&"}
        if let description = description { urlString += "description=\(description)&"}
        if let filmStock = filmStock { urlString += "filmStock=\(filmStock)&"}

        if let page = page, let limit = limit {
            urlString += ("page=\(page)&limit=\(limit)")
        }

        guard let url = URL(string: urlString.replacingOccurrences(of: " ", with: "+")) else {
            throw HttpError.badURL
        }
        return try await HttpClient.shared.fetch(url: url)
    }

    func getCreatorUsername(userUID: String) async throws -> String {
        guard let url = URL(string: Constants.usersURL + "/\(userUID)/username") else {
            throw HttpError.badURL
        }

        let username: Username = try await HttpClient.shared.fetchSingleObject(url: url)
        return username.value
    }
}
