import UIKit

public extension UISlider {
    func set(value: Float) {
        guard isEnabled else { return }

        setValue(value, animated: false)
        sendActions(for: .valueChanged)
    }
}
