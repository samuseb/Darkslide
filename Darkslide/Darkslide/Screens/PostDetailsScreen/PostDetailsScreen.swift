import SwiftUI

struct PostDetailsScreen: View {
    private enum Constants {
        static let dataSpacing: CGFloat = 10.0
        static let cornerRadius: CGFloat = 8.0
    }

    @StateObject var viewModel: PostViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Image(uiImage: UIImage(data: viewModel.post.imageData) ?? UIImage(ciImage: .empty()))
                        .resizable()
                        .aspectRatio(contentMode: .fit)

                    DescriptionCard(
                        username: viewModel.creatorUsername,
                        userUID: viewModel.post.userUID,
                        description: viewModel.post.description
                    )
                }
                .background {
                    Asset.Colors.darkGray.swiftUIColor
                        .cornerRadius(Constants.cornerRadius)
                }

                HStack {
                    Text(L10n.Post.photoDetails)
                        .defaultText()
                        .font(.title2)
                        .underline()
                    Spacer()
                }
                .padding([.leading, .bottom])
                .padding(.top, Layout.padding30)

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: Constants.dataSpacing) {
                        PhotoDataLabel(
                            title: L10n.Post.format,
                            value: viewModel.post.digital ? L10n.Post.digital : L10n.Post.film
                        )
                        PhotoDataLabel(title: L10n.Post.camera, value: viewModel.post.camera)
                        PhotoDataLabel(title: L10n.Post.shutterSpeed, value: viewModel.post.shutterSpeed?.formatted())
                        PhotoDataLabel(
                            title: L10n.Post.iso,
                            value: viewModel.post.iso == nil ? nil : String(viewModel.post.iso!)
                        )
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: Constants.dataSpacing) {
                        if !viewModel.post.digital {
                            PhotoDataLabel(title: L10n.Post.filmStock, value: viewModel.post.filmStock)
                        } else {
                        }
                        PhotoDataLabel(title: L10n.Post.lens, value: viewModel.post.lens)
                        PhotoDataLabel(title: L10n.Post.aperture, value: viewModel.post.aperture?.formatted())

                    }
                }
                .padding(.horizontal, Layout.padding20)

                HStack {
                    Text(viewModel.post.timeStamp.yearMonthDayFormat())
                        .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                        .italic()
                        .padding()
                    Spacer()
                }

                Divider()

                Button {
                    viewModel.focusCommentTextFieldOnAppear = false
                    viewModel.showComments = true
                } label: {
                    VStack(alignment: .leading) {
                        ForEach(
                            viewModel.comments.count >= 5 ? Array(viewModel.comments[0...4]) : viewModel.comments
                        ) { comment in
                            CommentRow(comment: comment, showDeleteIcon: false)
                        }
                    }
                }

                Button {
                    viewModel.focusCommentTextFieldOnAppear = true
                    viewModel.showComments = true
                } label: {
                    Text("Write a comment...")
                        .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                        .italic()
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Asset.Colors.darkBackground.swiftUIColor)
        .toolbar {
            if viewModel.authenticationService.signedInUserUID == viewModel.post.userUID &&
                viewModel.showEditButton {
                Button {
                    viewModel.showEditScreen = true
                } label: {
                    Text(L10n.General.edit)
                }
            }
        }
        .snackbar(text: viewModel.snackBarMessage, isShowing: $viewModel.showSnackBar)
        .fullScreenCover(isPresented: $viewModel.showEditScreen) {
            PostEditScreen(
                viewModel: PostEditViewModel(
                    post: viewModel.post,
                    removeFromListOnDeleteAction: viewModel.onDeletePostAction
                )
            ) {
                dismiss()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showComments) {
            CommentsScreen(viewModel: viewModel)
        }
    }
}

struct PostDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailsScreen(viewModel: PostViewModel(post: Post.mockHorizontal))
    }
}
