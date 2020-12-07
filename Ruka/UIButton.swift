import UIKit

public extension UIButton {
    func tap() {
        guard isEnabled else { return }

        sendActions(for: .touchUpInside)
        RunLoop.current.run(until: Date())
    }
}
