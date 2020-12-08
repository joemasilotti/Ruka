import UIKit

public extension UISwitch {
    func toggle() {
        if isEnabled {
            sendActions(for: .valueChanged)
        }
    }
}
