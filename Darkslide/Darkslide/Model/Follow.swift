import Foundation

final class Follow: Codable {
    var followerUID: String
    var followedUID: String

    init(followerUID: String, followedUID: String) {
        self.followerUID = followerUID
        self.followedUID = followedUID
    }
}
