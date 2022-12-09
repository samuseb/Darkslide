import Factory
import Foundation

extension Container {
    static let authenticationService = Factory { FireBaseAuthenticationService() as AuthenticationService }
    static let postService = Factory { VaporPostSerice() as PostService }
    static let userService = Factory { VaporUserService() as UserService }
    static let followService = Factory { VaporFollowService() as FollowService }
    static let commentService = Factory { VaporCommentService() as CommentService }
}
