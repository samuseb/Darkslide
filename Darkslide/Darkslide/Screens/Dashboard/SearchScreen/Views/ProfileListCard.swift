import SwiftUI

struct ProfileListCard: View {
    var user: User

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(.white, lineWidth: 2)
                .frame(height: 65.0)
            HStack {
                if let imageData = user.profilePhotoData {
                    Image(uiImage: UIImage(data: imageData) ?? UIImage())
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .padding(.leading, Layout.padding10)
                } else {
                    Circle()
                        .frame(width: 50, height: 50)
                        .padding(.leading, Layout.padding10)
                        .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
                }
                VStack(alignment: .leading) {
                    Text(user.userName)
                        .defaultText()
                        .bold()
                    Text(user.bioDescription ?? String.empty)
                        .defaultText()
                        .lineLimit(2)
                        .font(.system(size: 10))
                }
                .frame(height: 50)
                .padding(.horizontal, Layout.padding5)

                Spacer()
            }
        }
    }
}

struct ProfileListCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Asset.Colors.darkBackground.swiftUIColor)
            ProfileListCard(user: User.mock)
                .padding()
        }
    }
}
