import UIKit

public extension UISwitch {
    func toggle() {
        guard isEnabled else { return }
        
        sendActions(for: .valueChanged)
    }
}
