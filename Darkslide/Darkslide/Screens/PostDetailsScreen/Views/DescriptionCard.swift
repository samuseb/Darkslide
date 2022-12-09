import SwiftUI

struct DescriptionCard: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 8.0
        static let usernameSize = 20.0
    }

    let username: String?
    let userUID: String?
    let description: String?

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let username = username, let userUID = userUID {
                    NavigationLink(value: HashableUserUID(uid: userUID)) {
                        Text(username)
                            .defaultText()
                            .font(.system(size: Constants.usernameSize))
                            .bold()
                            .padding(.horizontal)
                        .padding(.vertical, Layout.padding10)
                    }
                }
                if let description = description {
                    Text(description)
                        .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                        .fontWeight(.medium)
                        .italic()
                        .padding(.horizontal)
                        .padding(.vertical, Layout.padding10)
                }
            }

            Spacer()
        }
        .background {
            Asset.Colors.darkGray.swiftUIColor
                .cornerRadius(Constants.cornerRadius)
        }
    }
}

struct DescriptionCard_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionCard(
            username: "Béla",
            userUID: String.empty,
            description: Post.mockHorizontal.description
        )
    }
}
