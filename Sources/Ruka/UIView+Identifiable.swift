import UIKit

extension UIView {
    func isIdentifiable(by identifier: String, in controller: UIViewController) -> Bool {
        let identifiable =
            (self as? Identifiable)?.isIdentifiable(by: identifier) ?? false ||
            accessibilityLabel == identifier ||
            accessibilityIdentifier == identifier

        return identifiable && !isHidden && frame.intersects(controller.view.bounds)
    }
}
