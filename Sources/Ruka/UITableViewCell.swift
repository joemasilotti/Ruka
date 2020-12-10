import UIKit

public extension UITableViewCell {
    func tap() {
        guard
            let tableView = superview as? UITableView,
            let indexPath = tableView.indexPath(for: self)
        else { return }

        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
}
