import SwiftUI

struct CommentRow: View {

    var comment: Comment

    var showDeleteIcon: Bool

    var deleteAction: ( () -> Void )

    init(
        comment: Comment,
        showDeleteIcon: Bool = false,
        deleteAction: @escaping (() -> Void) = {}
    ) {
        self.comment = comment
        self.showDeleteIcon = showDeleteIcon
        self.deleteAction = deleteAction
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(comment.userName + ": ")
                    .defaultText()
                    .bold()
                Text(comment.text)
                    .defaultText()
                    .multilineTextAlignment(.leading)

                Spacer()

                if showDeleteIcon {
                    Button {
                        deleteAction()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .foregroundColor(.red)
                }
            }
            .padding(.horizontal)
            Divider()
                .padding(.leading)
        }
    }
}

struct CommentRow_Previews: PreviewProvider {
    static var previews: some View {
        CommentRow(comment: Comment.mock, showDeleteIcon: true)
            .background {
                Asset.Colors.darkBackground.swiftUIColor
            }
    }
}
