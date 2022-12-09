import Foundation

extension String {
    static let empty = ""

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }

    func isAlphanumericOnly() -> Bool {
        let alphanumericRegex = "^[a-zA-Z0-9_]*$"

        let pred = NSPredicate(format: "SELF MATCHES %@", alphanumericRegex)
        return pred.evaluate(with: self)
    }

    func isValidUsername() -> Bool {
        return !self.isEmpty && self.isAlphanumericOnly() && self.count <= 20
    }
}
