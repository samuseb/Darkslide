import SwiftUI

extension View {
    func defaultText() -> some View {
        modifier(CustomText())
    }

    func defaultDarkText() -> some View {
        modifier(CustomDarkText())
    }

    func loadingIndicator(isShowing: Binding<Bool>) -> some View {
        modifier(LoadingIndicator(isShowing: isShowing))
    }

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }

    func snackbar(text: String, isShowing: Binding<Bool>, duration: Double = 3) -> some View {
        modifier(SnackBar(text: text, isShowing: isShowing))
    }
}

private struct CustomText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
    }
}

private struct SnackBar: ViewModifier {
    let text: String
    @Binding var isShowing: Bool
    var duration: Double = 3

    func body(content: Content) -> some View {
        content
            .overlay {
                if isShowing {
                    DSSnackBar(text: text)
                }
            }
            .animation(.spring(), value: isShowing)
            .onChange(of: isShowing) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    isShowing = false
                }
            }
    }
}

private struct CustomDarkText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
    }
}

private struct LoadingIndicator: ViewModifier {
    private enum Constants {
        static let progressViewScale = 1.5
        static let backgroundOpacity = 0.5
    }

    @Binding var isShowing: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if isShowing {
                    Rectangle()
                        .ignoresSafeArea()
                        .foregroundColor(.black)
                        .opacity(Constants.backgroundOpacity)
                        .overlay {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                                .scaleEffect(Constants.progressViewScale)
                        }
                }
            }
    }
}
