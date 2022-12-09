import SwiftUI

struct OnboardingScreen: View {
    var body: some View {
        VStack {
            Text(L10n.Onboarding.title)
                .defaultText()
                .font(.largeTitle)
                .bold()
                .padding()
                .padding(.top)

            Text(L10n.Onboarding.socialForPhotographers)
                .defaultText()
                .padding()

            Text(L10n.Onboarding.shareYourPhotos)
                .defaultText()
                .padding()
            Spacer()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Asset.Colors.darkBackground.swiftUIColor
                .ignoresSafeArea()
        }
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen()
    }
}
