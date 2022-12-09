import SwiftUI

struct FeedItemCard: View {
    private enum Constants {
        static let cornerRadius = 10.0
    }

    @StateObject var viewModel: FeedItemCardViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .foregroundColor(Color(asset: Asset.Colors.darkGray))
                .padding()
            VStack(alignment: .leading) {
                Text(viewModel.username ?? L10n.General.unknown)
                    .defaultText()
                    .bold()
                    .font(.title3)
                    .padding(.horizontal, Layout.padding10)
                    .padding(.top, Layout.padding10)

                Image(uiImage: UIImage(data: viewModel.post.imageData) ?? UIImage(ciImage: .empty()))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))

                Text(viewModel.post.description ?? String.empty)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                    .fontWeight(.medium)
                    .padding(Layout.padding10)
                    .lineLimit(5)
            }
            .padding()
        }
        .task {
            await viewModel.loadUsername()
        }
    }
}

struct FeedItemCard_Previews: PreviewProvider {
    @Namespace static var nameSpace

    static var previews: some View {
        Rectangle()
            .foregroundColor(Color(asset: Asset.Colors.darkBackground))
            .ignoresSafeArea()
            .overlay {
                ScrollView {
                    VStack {
                        FeedItemCard(viewModel: .init(post: Post.mockVertical))
                        FeedItemCard(viewModel: .init(post: Post.mockHorizontal))
                    }
                }
            }
    }
}
