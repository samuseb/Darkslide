import SwiftUI
import PhotosUI

struct CreatePostPhotoSelectorPage: View {
    private enum Constants {
        static let cornerRadius = 8.0
        static let imageHeight = 250.0
    }

    @ObservedObject var viewModel: CreatePostViewModel

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    Text("Create a post")
                        .font(Font.largeTitle)
                        .defaultText()
                        .padding(.vertical)

                    PhotosPicker(
                        selection: $viewModel.selectedPhotoPickerItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if viewModel.selectedPhotoPickerItem != nil {
                            Image(uiImage: UIImage(data: viewModel.selectedPhotoData ?? Data()) ?? UIImage())
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(Constants.cornerRadius)
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                    .foregroundColor(Asset.Colors.darkGray.swiftUIColor)
                                Text("Select a photo")
                                    .foregroundColor(Asset.Colors.controlTint.swiftUIColor)
                            }
                        }
                    }
                    .frame(height: Constants.imageHeight)
                    .padding(.horizontal)
                    .padding(.top)

                    DSMultilineTextField(placeHolder: "Write about your photo...", text: $viewModel.description)
                        .padding()

                    Text("Photo format")
                        .defaultText()
                        .padding(.top)
                    Picker("Authentication Type", selection: $viewModel.digital) {
                        Text("Film").tag(false)
                        Text("Digital").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .colorMultiply(Color.white)
                    .padding(.horizontal)

                }
//                DSButton(text: "Next", isDisabled: $viewModel.postDisabled) {}
//                    .padding()
                NavigationLink("Next", value: "")
                .navigationDestination(for: String.self) { _ in
                    CreatePostInfoPage()
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Asset.Colors.darkBackground.swiftUIColor)
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostPhotoSelectorPage(viewModel: CreatePostViewModel(postService: VaporPostSerice()))
    }
}
