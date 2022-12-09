import SwiftUI

struct ProfilePhotoEditScreen: View {
    private enum Constants {
        static let cornerRadius = 8.0
        static let imageHeight = 300.0
    }
    @ObservedObject var viewModel: AccountSettingsViewModel

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text(L10n.ProfilePhotoEdit.title)
                .defaultText()
                .font(.largeTitle)
                .bold()
                .padding(Layout.padding30)

            if let imageData = viewModel.selectedProfilePhotoData {
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
                    Text(L10n.ProfilePhotoEdit.choosePhoto)
                        .defaultText()
                }
                .padding()
                .onTapGesture {
                    viewModel.showPhotoPicker = true
                }
            }

            Spacer()

            DSButton(text: L10n.General.save, isDisabled: .constant(false)) {
                viewModel.saveProfilePhoto {
                    dismiss()
                }
            }
            .padding([.horizontal, .top])

            DSButton(text: L10n.ProfilePhotoEdit.deletePhoto, isDisabled: .constant(false), style: .destructive) {
                viewModel.showDeleteProfilePhotoAlert = true
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
            ImagePicker(imageData: $viewModel.selectedProfilePhotoData, enableCropping: true, compressionQuality: 0.2)
        }
        .alert(
            L10n.ProfilePhotoEdit.areYouSureYouWantToDelete,
            isPresented: $viewModel.showDeleteProfilePhotoAlert
        ) {
            Button(L10n.General.cancel, role: .cancel) {
                viewModel.showDeleteProfilePhotoAlert = false
            }

            Button(L10n.General.delete, role: .destructive) {
                viewModel.deleteProfilePhoto { dismiss() }
            }
        }
    }
}

struct ProfilePhotoEditScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoEditScreen(viewModel: AccountSettingsViewModel(user: User.mock))
    }
}
