import SwiftUI

struct GoogleSignInButton: View {
    private enum Constants {
        static let cornerRadius = 8.0
        static let height = 40.0
    }

    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundColor(.white)
                    .frame(height: Constants.height)
                HStack {
                    Asset.Images.google.swiftUIImage
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(.horizontal)
                    Spacer()
                }
                .overlay {
                    Text(L10n.Authentication.continueWithGoogle)
                        .foregroundColor(.black)
                        .bold()
                }
            }
        }
    }
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton {}
    }
}
