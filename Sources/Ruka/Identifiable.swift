import UIKit

protocol Identifiable {
    func isIdentifiable(by identifier: String) -> Bool
}

extension UILabel: Identifiable {
    func isIdentifiable(by identifier: String) -> Bool {
        text == identifier
    }
}

extension UIButton: Identifiable {
    func isIdentifiable(by identifier: String) -> Bool {
        title(for: .normal) == identifier
    }
}

extension UITextField: Identifiable {
    func isIdentifiable(by identifier: String) -> Bool {
        placeholder == identifier
    }
}
