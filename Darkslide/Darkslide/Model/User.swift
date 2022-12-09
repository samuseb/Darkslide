import Foundation

final class User: Codable, Identifiable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id && lhs.userUID == rhs.userUID
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id = UUID()
    var userUID: String
    var userName: String
    var coverPhotoData: Data?
    var profilePhotoData: Data?
    var bioDescription: String?

    init(
        userUID: String,
        userName: String,
        coverPhotoData: Data? = nil,
        profilePhotoData: Data? = nil,
        bioDescription: String? = nil
    ) {
        self.userUID = userUID
        self.userName = userName
        self.coverPhotoData = coverPhotoData
        self.profilePhotoData = profilePhotoData
        self.bioDescription = bioDescription
    }

    static let mock = User(
        userUID: "1234567890",
        userName: "Mock",
        bioDescription:
            """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit,
            sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
            Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
            nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
            reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
            Excepteur sint occaecat cupidatat non proident,
            sunt in culpa qui officia deserunt mollit anim id est laborum.
            """
    )
}
