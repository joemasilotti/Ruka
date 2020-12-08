import UIKit

extension UISwitch {
    func toggle() {
        if isEnabled {
            sendActions(for: .valueChanged)
        }
    }
}
