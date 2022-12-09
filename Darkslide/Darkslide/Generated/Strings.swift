// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Authentication {
    /// Authentication type
    internal static let authenticationType = L10n.tr("Localizable", "authentication.authenticationType", fallback: "Authentication type")
    /// Confirm Password
    internal static let confirmPassword = L10n.tr("Localizable", "authentication.confirmPassword", fallback: "Confirm Password")
    /// Continue with google
    internal static let continueWithGoogle = L10n.tr("Localizable", "authentication.continueWithGoogle", fallback: "Continue with google")
    /// E-mail
    internal static let email = L10n.tr("Localizable", "authentication.email", fallback: "E-mail")
    /// Something went wrong. Please try again.
    internal static let generalError = L10n.tr("Localizable", "authentication.generalError", fallback: "Something went wrong. Please try again.")
    /// Glad to have you!
    internal static let glad = L10n.tr("Localizable", "authentication.glad", fallback: "Glad to have you!")
    /// Invalid credentials
    internal static let invalidCredentials = L10n.tr("Localizable", "authentication.invalidCredentials", fallback: "Invalid credentials")
    /// Login
    internal static let login = L10n.tr("Localizable", "authentication.login", fallback: "Login")
    /// OR
    internal static let or = L10n.tr("Localizable", "authentication.or", fallback: "OR")
    /// Password
    internal static let password = L10n.tr("Localizable", "authentication.password", fallback: "Password")
    /// Passwords are not matching
    internal static let passwordsNotMatching = L10n.tr("Localizable", "authentication.passwordsNotMatching", fallback: "Passwords are not matching")
    /// Register
    internal static let register = L10n.tr("Localizable", "authentication.register", fallback: "Register")
    /// Username already exists
    internal static let usernameExists = L10n.tr("Localizable", "authentication.usernameExists", fallback: "Username already exists")
    /// Welcome to Darkslide
    internal static let welcome = L10n.tr("Localizable", "authentication.welcome", fallback: "Welcome to Darkslide")
    /// What is Darkslide?
    internal static let whatisdarkslide = L10n.tr("Localizable", "authentication.whatisdarkslide", fallback: "What is Darkslide?")
    /// Wrong e-mail or password
    internal static let wrongLoginInputs = L10n.tr("Localizable", "authentication.wrongLoginInputs", fallback: "Wrong e-mail or password")
  }
  internal enum BioEdit {
    /// Edit bio...
    internal static let placeholder = L10n.tr("Localizable", "bioEdit.placeholder", fallback: "Edit bio...")
    /// Edit bio
    internal static let title = L10n.tr("Localizable", "bioEdit.title", fallback: "Edit bio")
  }
  internal enum Comments {
    /// Are you sure you want to delete this comment?
    internal static let areYouSureYouWantToDelete = L10n.tr("Localizable", "comments.areYouSureYouWantToDelete", fallback: "Are you sure you want to delete this comment?")
    /// Load more...
    internal static let loadMore = L10n.tr("Localizable", "comments.loadMore", fallback: "Load more...")
    /// Maximum comment length is 250 characters.
    internal static let maximumLength = L10n.tr("Localizable", "comments.maximumLength", fallback: "Maximum comment length is 250 characters.")
    /// Comment posted.
    internal static let posted = L10n.tr("Localizable", "comments.posted", fallback: "Comment posted.")
    /// Write a comment...
    internal static let write = L10n.tr("Localizable", "comments.write", fallback: "Write a comment...")
  }
  internal enum CoverEdit {
    /// Are you sure you want to delete your cover photo?
    internal static let areYouSureYouWantToDelete = L10n.tr("Localizable", "coverEdit.areYouSureYouWantToDelete", fallback: "Are you sure you want to delete your cover photo?")
    /// Choose cover photo
    internal static let choosePhoto = L10n.tr("Localizable", "coverEdit.choosePhoto", fallback: "Choose cover photo")
    /// Couldn't delete cover photo. Please try again later.
    internal static let couldntDelete = L10n.tr("Localizable", "coverEdit.couldntDelete", fallback: "Couldn't delete cover photo. Please try again later.")
    /// Delete cover photo
    internal static let deletePhoto = L10n.tr("Localizable", "coverEdit.deletePhoto", fallback: "Delete cover photo")
  }
  internal enum CreateName {
    /// Username
    internal static let placeholder = L10n.tr("Localizable", "createName.placeholder", fallback: "Username")
    /// Choose a username
    internal static let title = L10n.tr("Localizable", "createName.title", fallback: "Choose a username")
  }
  internal enum CreatePost {
    /// Description
    internal static let description = L10n.tr("Localizable", "createPost.description", fallback: "Description")
    /// Write about your photo...
    internal static let descriptionPlaceholder = L10n.tr("Localizable", "createPost.descriptionPlaceholder", fallback: "Write about your photo...")
    /// Digital
    internal static let digital = L10n.tr("Localizable", "createPost.digital", fallback: "Digital")
    /// Film
    internal static let film = L10n.tr("Localizable", "createPost.film", fallback: "Film")
    /// Next
    internal static let next = L10n.tr("Localizable", "createPost.next", fallback: "Next")
    /// Photo format
    internal static let photoFormat = L10n.tr("Localizable", "createPost.photoFormat", fallback: "Photo format")
    /// Select aperture
    internal static let selectAperture = L10n.tr("Localizable", "createPost.selectAperture", fallback: "Select aperture")
    /// Select ISO
    internal static let selectISO = L10n.tr("Localizable", "createPost.selectISO", fallback: "Select ISO")
    /// Select a photo
    internal static let selectPhoto = L10n.tr("Localizable", "createPost.selectPhoto", fallback: "Select a photo")
    /// Select shutter speed
    internal static let selectShutterSpeed = L10n.tr("Localizable", "createPost.selectShutterSpeed", fallback: "Select shutter speed")
    /// Share
    internal static let share = L10n.tr("Localizable", "createPost.share", fallback: "Share")
    /// Create a post
    internal static let title = L10n.tr("Localizable", "createPost.title", fallback: "Create a post")
  }
  internal enum EditPost {
    /// Are you sure you want to delete this post?
    internal static let areYouSure = L10n.tr("Localizable", "editPost.areYouSure", fallback: "Are you sure you want to delete this post?")
    /// Delete post
    internal static let delete = L10n.tr("Localizable", "editPost.delete", fallback: "Delete post")
    /// Edit post
    internal static let title = L10n.tr("Localizable", "editPost.title", fallback: "Edit post")
  }
  internal enum Feed {
    /// Looks lke you got to the bottom of it.
    internal static let bottomOfFeed = L10n.tr("Localizable", "feed.bottomOfFeed", fallback: "Looks lke you got to the bottom of it.")
    /// Couldn't load posts.
    internal static let couldntLoad = L10n.tr("Localizable", "feed.couldntLoad", fallback: "Couldn't load posts.")
    /// Feed
    internal static let title = L10n.tr("Localizable", "feed.title", fallback: "Feed")
    /// You should follow some people to see their content here.
    internal static let youShouldFollow = L10n.tr("Localizable", "feed.youShouldFollow", fallback: "You should follow some people to see their content here.")
  }
  internal enum General {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "general.cancel", fallback: "Cancel")
    /// Close
    internal static let close = L10n.tr("Localizable", "general.close", fallback: "Close")
    /// Couldn't load data.
    internal static let couldntLoadError = L10n.tr("Localizable", "general.couldntLoadError", fallback: "Couldn't load data.")
    /// Delete
    internal static let delete = L10n.tr("Localizable", "general.delete", fallback: "Delete")
    /// Edit
    internal static let edit = L10n.tr("Localizable", "general.edit", fallback: "Edit")
    /// Follow
    internal static let follow = L10n.tr("Localizable", "general.follow", fallback: "Follow")
    /// Ok
    internal static let ok = L10n.tr("Localizable", "general.ok", fallback: "Ok")
    /// Post
    internal static let post = L10n.tr("Localizable", "general.post", fallback: "Post")
    /// Save
    internal static let save = L10n.tr("Localizable", "general.save", fallback: "Save")
    /// Something went wrong.
    internal static let somethingWrongAlert = L10n.tr("Localizable", "general.somethingWrongAlert", fallback: "Something went wrong.")
    /// Something went wrong. Please try again later.
    internal static let somethingWrongTryAgain = L10n.tr("Localizable", "general.somethingWrongTryAgain", fallback: "Something went wrong. Please try again later.")
    /// Unfollow
    internal static let unfollow = L10n.tr("Localizable", "general.unfollow", fallback: "Unfollow")
    /// Unknown
    internal static let unknown = L10n.tr("Localizable", "general.unknown", fallback: "Unknown")
  }
  internal enum Onboarding {
    /// Share your photos on Darkslide whether it was taken on film or digital.
    internal static let shareYourPhotos = L10n.tr("Localizable", "onboarding.shareYourPhotos", fallback: "Share your photos on Darkslide whether it was taken on film or digital.")
    /// Darkslide is a social media platform focused on photographers.
    internal static let socialForPhotographers = L10n.tr("Localizable", "onboarding.socialForPhotographers", fallback: "Darkslide is a social media platform focused on photographers.")
    /// What is Darkslide?
    internal static let title = L10n.tr("Localizable", "onboarding.title", fallback: "What is Darkslide?")
  }
  internal enum Post {
    /// Aperture
    internal static let aperture = L10n.tr("Localizable", "post.aperture", fallback: "Aperture")
    /// Camera
    internal static let camera = L10n.tr("Localizable", "post.camera", fallback: "Camera")
    /// Couldn't delete post. Please try again later.
    internal static let couldntDeleteError = L10n.tr("Localizable", "post.couldntDeleteError", fallback: "Couldn't delete post. Please try again later.")
    /// Couldn't update post. Please try again later.
    internal static let couldntUpdateError = L10n.tr("Localizable", "post.couldntUpdateError", fallback: "Couldn't update post. Please try again later.")
    /// Digital
    internal static let digital = L10n.tr("Localizable", "post.digital", fallback: "Digital")
    /// Film
    internal static let film = L10n.tr("Localizable", "post.film", fallback: "Film")
    /// Film stock
    internal static let filmStock = L10n.tr("Localizable", "post.filmStock", fallback: "Film stock")
    /// Format
    internal static let format = L10n.tr("Localizable", "post.format", fallback: "Format")
    /// ISO
    internal static let iso = L10n.tr("Localizable", "post.iso", fallback: "ISO")
    /// Lens
    internal static let lens = L10n.tr("Localizable", "post.lens", fallback: "Lens")
    /// Photo Details
    internal static let photoDetails = L10n.tr("Localizable", "post.photoDetails", fallback: "Photo Details")
    /// Shutter speed
    internal static let shutterSpeed = L10n.tr("Localizable", "post.shutterSpeed", fallback: "Shutter speed")
  }
  internal enum Profile {
    /// Couldn't load user data.
    internal static let couldntLoadData = L10n.tr("Localizable", "profile.couldntLoadData", fallback: "Couldn't load user data.")
    /// Follow
    internal static let follow = L10n.tr("Localizable", "profile.follow", fallback: "Follow")
    /// Followers
    internal static let followers = L10n.tr("Localizable", "profile.followers", fallback: "Followers")
    /// Posts
    internal static let posts = L10n.tr("Localizable", "profile.posts", fallback: "Posts")
    /// Profile
    internal static let title = L10n.tr("Localizable", "profile.title", fallback: "Profile")
  }
  internal enum ProfilePhotoEdit {
    /// Are you sure you want to delete your profile photo?
    internal static let areYouSureYouWantToDelete = L10n.tr("Localizable", "profilePhotoEdit.areYouSureYouWantToDelete", fallback: "Are you sure you want to delete your profile photo?")
    /// Choose profile photo
    internal static let choosePhoto = L10n.tr("Localizable", "profilePhotoEdit.choosePhoto", fallback: "Choose profile photo")
    /// Couldn't delete profile photo. Please try again later
    internal static let couldntDelete = L10n.tr("Localizable", "profilePhotoEdit.couldntDelete", fallback: "Couldn't delete profile photo. Please try again later")
    /// Delete profile photo
    internal static let deletePhoto = L10n.tr("Localizable", "profilePhotoEdit.deletePhoto", fallback: "Delete profile photo")
    /// Edit profile photo
    internal static let title = L10n.tr("Localizable", "profilePhotoEdit.title", fallback: "Edit profile photo")
  }
  internal enum ProfileSettings {
    /// About
    internal static let about = L10n.tr("Localizable", "profileSettings.about", fallback: "About")
    /// Are you sure you want to delete your account? You can't undo this later.
    internal static let areYouSureDelete = L10n.tr("Localizable", "profileSettings.areYouSureDelete", fallback: "Are you sure you want to delete your account? You can't undo this later.")
    /// Delete account
    internal static let deleteAccount = L10n.tr("Localizable", "profileSettings.deleteAccount", fallback: "Delete account")
    /// Edit bio
    internal static let editBio = L10n.tr("Localizable", "profileSettings.editBio", fallback: "Edit bio")
    /// Edit cover photo
    internal static let editCoverPhoto = L10n.tr("Localizable", "profileSettings.editCoverPhoto", fallback: "Edit cover photo")
    /// Edit profile photo
    internal static let editProfilePhoto = L10n.tr("Localizable", "profileSettings.editProfilePhoto", fallback: "Edit profile photo")
    /// Please re-authenticate yourself
    internal static let reauthRequestTitle = L10n.tr("Localizable", "profileSettings.reauthRequestTitle", fallback: "Please re-authenticate yourself")
    /// Sign out
    internal static let signOut = L10n.tr("Localizable", "profileSettings.signOut", fallback: "Sign out")
    /// Settings
    internal static let title = L10n.tr("Localizable", "profileSettings.title", fallback: "Settings")
  }
  internal enum Search {
    /// Camera
    internal static let camera = L10n.tr("Localizable", "search.camera", fallback: "Camera")
    /// Film stock
    internal static let filmStock = L10n.tr("Localizable", "search.filmStock", fallback: "Film stock")
    /// In description
    internal static let inDescription = L10n.tr("Localizable", "search.inDescription", fallback: "In description")
    /// Lens
    internal static let lens = L10n.tr("Localizable", "search.lens", fallback: "Lens")
    /// Search...
    internal static let placeholder = L10n.tr("Localizable", "search.placeholder", fallback: "Search...")
    /// Posts
    internal static let posts = L10n.tr("Localizable", "search.posts", fallback: "Posts")
    /// Profiles
    internal static let profiles = L10n.tr("Localizable", "search.profiles", fallback: "Profiles")
    /// Search
    internal static let title = L10n.tr("Localizable", "search.title", fallback: "Search")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
