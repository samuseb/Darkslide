import SwiftUI

struct CommentsScreen: View {
    private enum Constants {
        static let cornerRadius = 8.0
        static let commentTextFieldLineLimit = 5
        static let springResponse = 0.2
        static let springDF = 0.5
    }

    @ObservedObject var viewModel: PostViewModel

    @FocusState private var commentInFocus: Bool

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Text(L10n.General.close)
                        .foregroundColor(Asset.Colors.controlTint.swiftUIColor)
                        .padding()
                }
            }
            ScrollView {
                ForEach(viewModel.comments) { comment in
                    if comment.userUID == viewModel.authenticationService.signedInUserUID {
                        CommentRow(
                            comment: comment,
                            showDeleteIcon: true
                        ) {
                            viewModel.selectedComment = comment
                            viewModel.showDeleteCommentAlert = true
                        }
                        .transition(.slide)
                    } else {
                        CommentRow(
                            comment: comment,
                            showDeleteIcon: false
                        )
                    }

                }
                .animation(
                    .spring(
                        response: Constants.springResponse,
                        dampingFraction: Constants.springDF,
                        blendDuration: .zero),
                    value: viewModel.comments
                )

                if !viewModel.allCommentsFetched {
                    HStack {
                        Button {
                            viewModel.fetchNextComments()
                        } label: {
                            Text(L10n.Comments.loadMore)
                        }
                        .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                        Spacer()
                    }
                    .padding()
                }
            }
            .padding(.top)
            .refreshable {
                viewModel.refreshComments()
            }

            if viewModel.showTooLongComment {
                Text(L10n.Comments.maximumLength)
                    .foregroundColor(.red)
            }
            HStack {
                TextField(L10n.Comments.write, text: $viewModel.commentInput, axis: .vertical)
                    .padding(Layout.padding10)
                    .background(Asset.Colors.darkGray.swiftUIColor)
                    .cornerRadius(Constants.cornerRadius)
                    .focused($commentInFocus)
                    .padding()
                    .lineLimit(Constants.commentTextFieldLineLimit)

                Button {
                    viewModel.postCommentPressed()
                } label: {
                    Text(L10n.General.post)
                }
                .foregroundColor(Asset.Colors.controlTint.swiftUIColor)
                .padding(.trailing)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Asset.Colors.darkBackground.swiftUIColor
                .ignoresSafeArea()
        }
        .snackbar(text: viewModel.snackBarMessage, isShowing: $viewModel.showSnackBar)
        .onAppear {
            commentInFocus = viewModel.focusCommentTextFieldOnAppear
            viewModel.showTooLongComment = false
        }
        .alert(L10n.Comments.areYouSureYouWantToDelete, isPresented: $viewModel.showDeleteCommentAlert) {
            Button(L10n.General.cancel, role: .cancel) {
                viewModel.showDeleteCommentAlert = false
            }

            Button(L10n.General.delete, role: .destructive) {
                viewModel.deleteSelectedComment()
            }
        }
    }
}

struct CommentsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CommentsScreen(viewModel: PostViewModel(post: Post.mockVertical))
    }
}
