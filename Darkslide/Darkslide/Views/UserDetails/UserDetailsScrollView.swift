import SwiftUI

struct UserDetailsScrollView: View {
    private enum Constants {
        static let gridItemMinWidth: CGFloat = 170
        static let gridItemMaxWidth: CGFloat = 180
        static let placeholderRectangleHeight: CGFloat = 150
        static let infoSpacing: CGFloat = 100
        static let cornerRadius: CGFloat = 8
        static let bottomCardOffset: CGFloat = -20
        static let gridSpacing: CGFloat = 10
        static let imageTopPadding: CGFloat = 40
    }

    let columns = [
        GridItem(.adaptive(minimum: Constants.gridItemMinWidth, maximum: Constants.gridItemMaxWidth), spacing: .zero)
    ]

    @Binding var user: User?
    @Binding var posts: [Post]
    @Binding var postCount: Int?
    @Binding var followerCount: Int?

    var fetchNextPosts: () -> Void

    var body: some View {
        ScrollView {
            if let coverPhotoData = user?.coverPhotoData {
                Rectangle()
                    .frame(height: Constants.imageTopPadding)
                    .foregroundColor(.clear)
                Image(uiImage: UIImage(data: coverPhotoData) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .frame(height: Constants.placeholderRectangleHeight)
                    .foregroundColor(.clear)
            }

            HStack(spacing: Constants.infoSpacing) {
                VStack {
                    Text(L10n.Profile.posts)
                        .defaultText()
                        .bold()
                    Text("\(postCount ?? .zero)")
                        .defaultText()
                }
                VStack {
                    Text(L10n.Profile.followers)
                        .defaultText()
                        .bold()
                    Text("\(followerCount ?? .zero)")
                        .defaultText()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Asset.Colors.darkBackground.swiftUIColor)
            .cornerRadius(Constants.cornerRadius)
            .offset(y: Constants.bottomCardOffset)

            if let bio = user?.bioDescription {
                Text(bio)
                    .defaultText()
                    .italic()
                    .padding()
            }

            LazyVGrid(columns: columns, spacing: Constants.gridSpacing) {
                ForEach(posts.indices, id: \.self) { index in
                    NavigationLink(value: posts[index]) {
                        GridCard(post: $posts[index])
                            .onAppear {
                                if index == posts.count - 1 {
                                    fetchNextPosts()
                                }
                            }
                    }
                }
            }
            .padding(Layout.padding5)
        }
        .background(Color(asset: Asset.Colors.darkBackground))
        .navigationTitle(L10n.Profile.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserDetailsScrollView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsScrollView(
            user: .constant(User.mock),
            posts: .constant([Post.mockVertical]),
            postCount: .constant(1),
            followerCount: .constant(1)
        ) {}
    }
}
