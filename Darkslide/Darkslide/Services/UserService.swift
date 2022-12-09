import Foundation

protocol UserService {
    func getUserByUID(_ userUID: String) async throws -> User
    func createUser(_ user: User) async throws
    func updateUser(_ user: User) async throws
    func getUserPostCount(_ user: User) async throws -> Int
    func getUserFollowerCount(_ user: User) async throws -> Int
    func deleteUserData(_ user: User) async throws
    func searchForUsers(searchTerm: String, page: Int?, limit: Int?) async throws -> [User]
    func usernameExists(_ username: String) async throws -> Bool
}

final class VaporUserService: UserService {
    private enum Constants {
        static let usersURL = "http://127.0.0.1:8080/users"
        static let postsURL = "http://127.0.0.1:8080/posts"
        static let followsURL = "http://127.0.0.1:8080/follows"
        static let commentsURL = "http://127.0.0.1:8080/comments"
    }

    func getUserByUID(_ userUID: String) async throws -> User {
        guard let url = URL(string: Constants.usersURL + "/\(userUID)") else {
            throw HttpError.badURL
        }

        let user: User = try await HttpClient.shared.fetchSingleObject(url: url)
        return user
    }

    func createUser(_ user: User) async throws {
        guard let url = URL(string: Constants.usersURL) else {
            throw HttpError.badURL
        }

        try await HttpClient.shared.sendData(to: url, object: user, httpMethod: "POST")
    }

    func updateUser(_ user: User) async throws {
        guard let url = URL(string: Constants.usersURL) else {
            throw HttpError.badURL
        }

        try await HttpClient.shared.sendData(to: url, object: user, httpMethod: "PUT")
    }

    func getUserPostCount(_ user: User) async throws -> Int {
        guard let url = URL(string: Constants.postsURL + "/\(user.userUID)/count") else {
            throw HttpError.badURL
        }
        let count: Count = try await HttpClient.shared.fetchSingleObject(url: url)
        return count.value
    }

    func getUserFollowerCount(_ user: User) async throws -> Int {
        guard let url = URL(string: Constants.followsURL + "/\(user.userUID)/followers") else {
            throw HttpError.badURL
        }
        let count: Count = try await HttpClient.shared.fetchSingleObject(url: url)
        return count.value
    }

    func deleteUserData(_ user: User) async throws {
        guard let url = URL(string: Constants.usersURL + "/\(user.userUID)") else {
            throw HttpError.badURL
        }
        try await HttpClient.shared.delete(url: url)
        if let postDeleteUrl = URL(string: Constants.postsURL + "/deleteuser/\(user.userUID)"),
           let followDeleteUrl = URL(string: Constants.followsURL + "/deleteuser/\(user.userUID)"),
           let commentDeleteUrl = URL(string: Constants.commentsURL + "/deleteuser/\(user.userUID)") {
            do {
                try await HttpClient.shared.delete(url: postDeleteUrl)
                try await HttpClient.shared.delete(url: followDeleteUrl)
                try await HttpClient.shared.delete(url: commentDeleteUrl)
            } catch { return }
        }
    }

    func searchForUsers(searchTerm: String, page: Int? = nil, limit: Int? = nil) async throws -> [User] {
        var urlString = Constants.usersURL + "?search=\(searchTerm)"
        if let page = page, let limit = limit {
            urlString += "&page=\(page)&limit=\(limit)"
        }
        guard let url = URL(string: urlString.replacingOccurrences(of: " ", with: "+")) else {
            throw HttpError.badURL
        }
        return try await HttpClient.shared.fetch(url: url)
    }

    func usernameExists(_ username: String) async throws -> Bool {
        let urlString = Constants.usersURL + "/exists/\(username)"
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        let exists: Exists = try await HttpClient.shared.fetchSingleObject(url: url)
        return exists.value
    }
}
