import UIKit

public extension UIAlertController {
    private typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

    func tapButton(title: String) {
        let action = actions.first(where: { $0.title == title })
        if let action = action, let block = action.value(forKey: "handler") {
            let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
            handler(action)

            dismiss(animated: false)
            RunLoop.current.run(until: Date().addingTimeInterval(0.01))
        }
    }
}
