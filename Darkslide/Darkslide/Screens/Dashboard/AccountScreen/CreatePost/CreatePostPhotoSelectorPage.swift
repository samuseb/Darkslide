import SwiftUI
import PhotosUI

struct CreatePostPhotoSelectorPage: View {
    private enum Constants {
        static let cornerRadius = 8.0
        static let imageHeight = 250.0
    }

    @ObservedObject var viewModel: CreatePostViewModel
    var dismiss: () -> Void

    var body: some View {
        VStack {
            ScrollView {
                Text(L10n.CreatePost.title)
                    .font(.largeTitle)
                    .defaultText()
                    .padding(.vertical)

                Group {
                    if viewModel.selectedPhotoData != nil {
                        Image(uiImage: UIImage(data: viewModel.selectedPhotoData ?? Data()) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(Constants.cornerRadius)
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                .foregroundColor(Asset.Colors.darkGray.swiftUIColor)
                            Text(L10n.CreatePost.selectPhoto)
                                .foregroundColor(Asset.Colors.controlTint.swiftUIColor)
                        }
                    }
                }
                .frame(height: Constants.imageHeight)
                .padding(.horizontal)
                .padding(.top)
                .onTapGesture {
                    viewModel.showPhotoPicker = true
                }

                HStack {
                    Text(L10n.CreatePost.description)
                        .defaultText()
                        .padding([.top, .leading])
                    Spacer()
                }
                DSMultilineTextField(
                    placeHolder: L10n.CreatePost.descriptionPlaceholder,
                    text: $viewModel.description
                )
                .padding(.horizontal)

                HStack {
                    Text(L10n.CreatePost.photoFormat)
                        .defaultText()
                        .padding([.top, .leading])
                    Spacer()
                }
                Picker(L10n.CreatePost.photoFormat, selection: $viewModel.digital) {
                    Text(L10n.CreatePost.film).tag(false)
                    Text(L10n.CreatePost.digital).tag(true)
                }
                .pickerStyle(.segmented)
                .colorMultiply(Color.white)
                .padding(.horizontal)

                NavigationLink(value: String.empty) {
                    Text(L10n.CreatePost.next)
                        .defaultText()
                        .padding(.horizontal, Layout.padding20)
                        .padding(.vertical, Layout.padding10)
                        .background(Asset.Colors.controlTint.swiftUIColor)
                        .cornerRadius(Constants.cornerRadius)
                        .padding(.bottom)
                }
                .padding(.top)

                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Asset.Colors.darkBackground.swiftUIColor)
        .navigationDestination(for: String.self) { _ in
            CreatePostInfoPage(viewModel: viewModel) { dismiss() }
        }
        .sheet(isPresented: $viewModel.showPhotoPicker) {
            ImagePicker(imageData: $viewModel.selectedPhotoData, enableCropping: false)
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostPhotoSelectorPage(
            viewModel: CreatePostViewModel { _ in }
        ) { }
    }
}
