import SwiftUI

struct ExifDataPickerGroup: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    @Binding var shutterSpeed: ShutterSpeed?
    @Binding var aperture: Aperture?
    @Binding var iso: Int?

    var bigText = false

    var body: some View {
        Group {
            HStack {
                Text(L10n.Post.shutterSpeed)
                    .defaultText()
                    .font(bigText ? .title2 : nil)
                Picker(L10n.Post.shutterSpeed, selection: $shutterSpeed) {
                    Text(L10n.CreatePost.selectShutterSpeed).tag(nil as ShutterSpeed?)
                    ForEach(ShutterSpeed.allCases, id: \.self) { speed in
                        Text(speed.formatted()).tag(speed as ShutterSpeed?)
                    }
                }
                .tint(Asset.Colors.controlTint.swiftUIColor)
                .background(Asset.Colors.darkGray.swiftUIColor)
                .cornerRadius(Constants.cornerRadius)

                Spacer()
            }
            HStack {
                Text(L10n.Post.aperture)
                    .defaultText()
                    .font(bigText ? .title2 : nil)
                Picker(L10n.Post.aperture, selection: $aperture) {
                    Text(L10n.CreatePost.selectAperture).tag(nil as Aperture?)
                    ForEach(Aperture.allCases, id: \.self) { aperture in
                        Text(aperture.formatted()).tag(aperture as Aperture?)
                    }
                }
                .tint(Asset.Colors.controlTint.swiftUIColor)
                .background(Asset.Colors.darkGray.swiftUIColor)
                .cornerRadius(Constants.cornerRadius)
                Spacer()
            }
            HStack {
                Text(L10n.Post.iso)
                    .defaultText()
                    .font(bigText ? .title2 : nil)
                Picker(L10n.Post.iso, selection: $iso) {
                    Text(L10n.CreatePost.selectISO).tag(nil as Int?)
                    ForEach(1..<20) { index in
                        Text("\(index * 10)").tag(index * 10 as Int?)
                    }
                    ForEach(4..<10) { index in
                        Text("\(index * 50)").tag(index * 50 as Int?)
                    }
                    ForEach(5..<50) { index in
                        Text("\(index * 100)").tag(index * 100 as Int?)
                    }
                    ForEach(5..<51) { index in
                        Text("\(index * 1000)").tag(index * 1000 as Int?)
                    }
                    ForEach(2..<7) { index in
                        Text("\(index * 50000)").tag(index * 50000 as Int?)
                    }
                }
                .tint(Asset.Colors.controlTint.swiftUIColor)
                .background(Asset.Colors.darkGray.swiftUIColor)
                .cornerRadius(Constants.cornerRadius)
                Spacer()
            }
        }
    }
}

struct ExifDataPickerGroup_Previews: PreviewProvider {
    static var previews: some View {
        ExifDataPickerGroup(shutterSpeed: .constant(nil), aperture: .constant(nil), iso: .constant(nil))
    }
}
