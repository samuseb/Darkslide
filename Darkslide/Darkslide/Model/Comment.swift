import Foundation

final class Comment: Codable, Identifiable, Equatable {
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id &&
        lhs.timeStamp == rhs.timeStamp &&
        lhs.postID == rhs.postID &&
        lhs.userUID == rhs.userUID &&
        lhs.text == rhs.text
    }

    var id = UUID()
    var text: String
    var postID: String
    var userUID: String
    var userName: String
    var timeStamp: Date

    init(id: UUID = UUID(), text: String, postID: String, userUID: String, userName: String, timeStamp: Date) {
        self.id = id
        self.text = text
        self.postID = postID
        self.userUID = userUID
        self.userName = userName
        self.timeStamp = timeStamp
    }

    static let mock = Comment(
        text: "That's the greatest photo I've ever seen in my life dude.",
        postID: "whatevs",
        userUID: "null",
        userName: "Béla",
        timeStamp: Date()
    )
}
