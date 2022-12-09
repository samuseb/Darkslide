import SwiftUI

struct GridCard: View {
    @Binding var post: Post
    var body: some View {
        Image(
            uiImage: UIImage(
                data: UIImage(data: post.imageData)?.jpegData(compressionQuality: 0.1) ?? Data()
            ) ?? UIImage()
        )
        .resizable()
        .clipped()
        .aspectRatio(contentMode: .fill)
        .frame(width: 170, height: 230)
        .cornerRadius(8.0)
    }
}

struct GridCard_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            GridCard(post: .constant(Post.mockHorizontal))
            GridCard(post: .constant(Post.mockVertical))
        }
    }
}
