import SwiftUI

struct BioEditScreen: View {

    @ObservedObject var viewModel: AccountSettingsViewModel

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text(L10n.BioEdit.title)
                .defaultText()
                .font(.largeTitle)
                .bold()
                .padding(Layout.padding40)

            DSMultilineTextField(placeHolder: L10n.BioEdit.placeholder, text: $viewModel.bioEditText)
                .padding()

            Spacer()

            DSButton(text: L10n.General.save, isDisabled: .constant(false)) {
                viewModel.saveBio {
                    dismiss()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Asset.Colors.darkBackground.swiftUIColor
                .ignoresSafeArea()
        }
        .loadingIndicator(isShowing: $viewModel.showLoading)
    }
}

struct BioEditScreen_Previews: PreviewProvider {
    static var previews: some View {
        BioEditScreen(viewModel: AccountSettingsViewModel(user: User.mock))
    }
}
