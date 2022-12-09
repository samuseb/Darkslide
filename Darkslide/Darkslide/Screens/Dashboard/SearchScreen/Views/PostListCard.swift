import SwiftUI

struct PostListCard: View {
    var post: Post

    var body: some View {
        ZStack {
            HStack {
                Image(uiImage: UIImage(data: post.imageData) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipped()
                    .cornerRadius(8.0)

                VStack(alignment: .leading) {
                    Text(post.description ?? String.empty)
                        .defaultText()
                        .font(.system(size: 13))
                        .multilineTextAlignment(.leading)
                        .lineLimit(6)
                    if post.camera != nil || post.lens != nil {
                        HStack {
                            if let camera = post.camera {
                                Text(camera)
                                    .padding(.horizontal, Layout.padding4)
                                    .font(.system(size: 13, weight: .medium))
                                    .defaultText()
                                    .background {
                                        RoundedRectangle(cornerRadius: 8.0)
                                            .foregroundColor(Asset.Colors.controlTint.swiftUIColor)
                                    }
                            }
                            if let lens = post.lens {
                                Text(lens)
                                    .padding(.horizontal, Layout.padding4)
                                    .font(.system(size: 13, weight: .medium))
                                    .defaultText()
                                    .background {
                                        RoundedRectangle(cornerRadius: 8.0)
                                            .foregroundColor(Asset.Colors.controlTint.swiftUIColor)
                                    }
                            }
                        }
                        .padding(.vertical, Layout.padding2)
                    }
                }
                .frame(height: 120)
                .padding(.horizontal, Layout.padding5)
                Spacer()
            }
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(.white, lineWidth: 2)
                .frame(height: 120.0)
        }

    }
}

struct PostListCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PostListCard(post: Post.mockHorizontal)
            PostListCard(post: Post.mockVertical)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Asset.Colors.darkBackground.swiftUIColor.ignoresSafeArea()
        }
    }
}
