import SwiftUI

struct CreatePostPage: View {
    @StateObject var viewModel: CreatePostViewModel

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            CreatePostPhotoSelectorPage(viewModel: viewModel) { dismiss() }
        }
        .accentColor(Asset.Colors.controlTint.swiftUIColor)
    }
}

struct CreatePostPage_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostPage(viewModel: CreatePostViewModel { _ in })
    }
}
