import UIKit

public extension UIStepper {
    func increment() {
        guard isEnabled else { return }

        value += stepValue
        sendActions(for: .valueChanged)
    }

    func decrement() {
        guard isEnabled else { return }

        value -= stepValue
        sendActions(for: .valueChanged)
    }
}
