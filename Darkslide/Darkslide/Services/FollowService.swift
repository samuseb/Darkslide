import Foundation

protocol FollowService {
    func followExists(followerUID: String, followedUID: String) async throws -> Bool
    func createFollowing(followerUID: String, followedUID: String) async throws
    func deleteFollowing(followerUID: String, followedUID: String) async throws
}

final class VaporFollowService: FollowService {
    private enum Constants {
        static let baseUrl = "http://127.0.0.1:8080/follows"
    }

    func followExists(followerUID: String, followedUID: String) async throws -> Bool {
        guard let url = URL(string: Constants.baseUrl + "?follower=\(followerUID)&followed=\(followedUID)") else {
            throw HttpError.badURL
        }
        let follows: [Follow] = try await HttpClient.shared.fetch(url: url)
        return !follows.isEmpty
    }

    func createFollowing(followerUID: String, followedUID: String) async throws {
        guard let url = URL(string: Constants.baseUrl) else {
            throw HttpError.badURL
        }
        let follow = Follow(followerUID: followerUID, followedUID: followedUID)
        try await HttpClient.shared.sendData(to: url, object: follow, httpMethod: "POST")
    }

    func deleteFollowing(followerUID: String, followedUID: String) async throws {
        guard let url = URL(string: Constants.baseUrl + "?follower=\(followerUID)&followed=\(followedUID)") else {
            throw HttpError.badURL
        }
        try await HttpClient.shared.delete(url: url)
    }
}
