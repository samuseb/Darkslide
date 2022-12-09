import SwiftUI

struct CoverPhotoEditScreen: View {
    private enum Constants {
        static let cornerRadius = 8.0
        static let imageHeight = 300.0
    }
    @ObservedObject var viewModel: AccountSettingsViewModel

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text(L10n.ProfileSettings.editCoverPhoto)
                .defaultText()
                .font(.largeTitle)
                .bold()
                .padding(Layout.padding30)

            if let imageData = viewModel.selectedCoverPhotoData {
                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(Constants.cornerRadius)
                    .frame(maxHeight: Constants.imageHeight)
                    .padding()
                    .onTapGesture {
                        viewModel.showPhotoPicker = true
                    }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .frame(height: Constants.imageHeight)
                        .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                    Text(L10n.CoverEdit.choosePhoto)
                        .defaultText()
                }
                .padding()
                .onTapGesture {
                    viewModel.showPhotoPicker = true
                }
            }

            Spacer()

            DSButton(text: L10n.General.save, isDisabled: .constant(false)) {
                viewModel.saveCoverPhoto {
                    dismiss()
                }
            }
            .padding([.horizontal, .top])

            DSButton(text: L10n.CoverEdit.deletePhoto, isDisabled: .constant(false), style: .destructive) {
                viewModel.showDeleteCoverAlert = true
            }
            .padding([.horizontal, .top])

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Asset.Colors.darkBackground.swiftUIColor
                .ignoresSafeArea()
        }
        .loadingIndicator(isShowing: $viewModel.showLoading)
        .sheet(isPresented: $viewModel.showPhotoPicker) {
            ImagePicker(imageData: $viewModel.selectedCoverPhotoData, enableCropping: true)
        }
        .alert(
            L10n.CoverEdit.areYouSureYouWantToDelete,
            isPresented: $viewModel.showDeleteCoverAlert
        ) {
            Button(L10n.General.cancel, role: .cancel) {
                viewModel.showDeleteCoverAlert = false
            }

            Button(L10n.General.delete, role: .destructive) {
                viewModel.deleteCoverPhoto { dismiss() }
            }
        }
    }
}

struct CoverPhotoEditScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoverPhotoEditScreen(viewModel: AccountSettingsViewModel(user: User.mock))
    }
}
