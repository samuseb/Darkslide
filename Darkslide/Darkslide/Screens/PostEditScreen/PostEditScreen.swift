import SwiftUI

struct PostEditScreen: View {

    @StateObject var viewModel: PostEditViewModel
    var popAfterDelete: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            Text(L10n.EditPost.title)
                .defaultText()
                .font(.largeTitle)
                .padding(.vertical)

            VStack(alignment: .leading) {
                Text(L10n.CreatePost.description)
                    .defaultText()

                DSMultilineTextField(
                    placeHolder: L10n.CreatePost.descriptionPlaceholder,
                    text: $viewModel.description
                )
                .padding(.bottom)

                Text(L10n.CreatePost.photoFormat)
                    .defaultText()

                Picker(L10n.CreatePost.photoFormat, selection: $viewModel.digital) {
                    Text(L10n.CreatePost.film).tag(false)
                    Text(L10n.CreatePost.digital).tag(true)
                }
                .pickerStyle(.segmented)
                .colorMultiply(Color.white)
                .padding(.bottom)

                Group {
                    Text(L10n.Post.filmStock)
                        .defaultText()
                    DSTextField(placeHolder: L10n.Post.filmStock, text: $viewModel.filmStock)
                }
                .opacity(viewModel.digital ? .zero : 1)
                .animation(.easeIn, value: viewModel.digital)

                Text(L10n.Post.camera)
                    .defaultText()
                DSTextField(placeHolder: L10n.Post.camera, text: $viewModel.camera)
                Text(L10n.Post.lens)
                    .defaultText()
                DSTextField(placeHolder: L10n.Post.lens, text: $viewModel.lens)
                    .padding(.bottom)

                ExifDataPickerGroup(
                    shutterSpeed: $viewModel.shutterSpeed,
                    aperture: $viewModel.aperture,
                    iso: $viewModel.iso
                )

            }
            .padding()

            Spacer()

            DSButton(text: L10n.EditPost.title, isDisabled: .constant(false)) {
                Task {
                    await viewModel.updatePost()
                    dismiss()
                }
            }
            .padding()

            DSButton(
                text: L10n.EditPost.delete,
                isDisabled: .constant(false),
                style: .destructive) {
                    viewModel.showDeleteAlert = true
                }
                .padding()

            Button {
                dismiss()
            } label: {
                Text(L10n.General.cancel)
            }
            .foregroundColor(Asset.Colors.controlGray.swiftUIColor)

        }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background {
            Asset.Colors.darkBackground.swiftUIColor
                .ignoresSafeArea()
        }
        .alert(L10n.EditPost.areYouSure, isPresented: $viewModel.showDeleteAlert) {
            Button(L10n.General.delete, role: .destructive) {
                Task {
                    await viewModel.deletePost {
                        dismiss()
                        popAfterDelete()
                    }
                }
            }
            Button(L10n.General.cancel, role: .cancel) {
                viewModel.showDeleteAlert = false
            }
        }
        .snackbar(text: viewModel.errorMessage, isShowing: $viewModel.showSnackBar)
        .loadingIndicator(isShowing: $viewModel.showLoading)
    }
}

struct PostEditScreen_Previews: PreviewProvider {
    static var previews: some View {
        PostEditScreen(viewModel: PostEditViewModel(post: Post.mockHorizontal)) {}
    }
}
