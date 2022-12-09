import SwiftUI

struct CreatePostInfoPage: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 8.0
    }

    @ObservedObject var viewModel: CreatePostViewModel
    var dismiss: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            if !viewModel.digital {
                Text(L10n.Post.filmStock)
                    .defaultText()
                    .font(.title2)
                DSTextField(placeHolder: L10n.Post.filmStock, text: $viewModel.filmStock)
            }
            Text(L10n.Post.camera)
                .defaultText()
                .font(.title2)
            DSTextField(placeHolder: L10n.Post.camera, text: $viewModel.camera)
            Text(L10n.Post.lens)
                .defaultText()
                .font(.title2)
            DSTextField(placeHolder: L10n.Post.lens, text: $viewModel.lens)
                .padding(.bottom)
            ExifDataPickerGroup(
                shutterSpeed: $viewModel.shutterSpeed,
                aperture: $viewModel.aperture,
                iso: $viewModel.iso,
                bigText: true
            )

            Spacer()

            VStack {
                DSButton(text: L10n.CreatePost.share, isDisabled: $viewModel.shareDisabled) {
                    Task {
                        await viewModel.sharePost {
                            DispatchQueue.main.async {
                                dismiss()
                            }
                        }
                    }
                }
                .padding(.top)
                Button {
                     dismiss()
                } label: {
                    Text(L10n.General.cancel)
                        .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                }
                .padding(.top)
            }

        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Asset.Colors.darkBackground.swiftUIColor)
        .snackbar(text: L10n.General.somethingWrongAlert, isShowing: $viewModel.showError)
    }
}

struct CreatePostInfoPage_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostInfoPage(
            viewModel: CreatePostViewModel { _ in }
        ) { }
    }
}
