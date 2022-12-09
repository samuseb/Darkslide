import SwiftUI

struct PhotoDataLabel: View {
    let title: String
    let value: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .defaultText()
                .bold()

            Text(value ?? "---")
                .foregroundColor(Asset.Colors.controlGray.swiftUIColor)
        }
    }
}

struct PhotoDataLabel_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDataLabel(title: "Camera", value: "Nikon F3")
            .padding()
            .background(.black)
    }
}
