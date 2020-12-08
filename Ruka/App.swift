import XCTest

public struct App {
    public enum FailureBehavior {
        case failTest
        case raiseException
        case doNothing
    }

    private enum RukaError: Error {
        case unfoundElement
    }

    public var alertViewController: UIAlertController? {
        controller as? UIAlertController
    }

    public var tableView: UITableView? {
        controller.view.findViews(subclassOf: UITableView.self).first
    }

    internal var controller: UIViewController! {
        if let navigationController = window.rootViewController as? UINavigationController {
            return navigationController.topViewController
        } else if let presentedController = window.rootViewController?.presentedViewController {
            return presentedController
        }
        return window.rootViewController
    }

    private let failureBehavior: FailureBehavior
    private let window = UIWindow()

    public init(controller: UIViewController, failureBehavior: FailureBehavior = .failTest) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        controller.view.layoutIfNeeded()

        self.failureBehavior = failureBehavior
    }

    public func label(text: String, file: StaticString = #filePath, line: UInt = #line) throws -> UILabel? {
        let labels = controller.view.findViews(subclassOf: UILabel.self)
        let label = labels.first(where: { $0.text == text && !$0.isHidden })

        if label == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find label with text '\(text)'.", file: file, line: line)
        }
        return label
    }

    public func button(title: String, file: StaticString = #filePath, line: UInt = #line) throws -> UIButton? {
        let buttons = controller.view.findViews(subclassOf: UIButton.self)
        let button = buttons.first(where: { $0.title(for: .normal) == title && !$0.isHidden })

        if button == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find button with text '\(title)'.", file: file, line: line)
        }
        return button
    }

    public func cell(containingText text: String, file: StaticString = #filePath, line: UInt = #line) throws -> UITableViewCell? {
        let tableViewCell = tableView?.visibleCells.first(where: { cell -> Bool in
            cell.findViews(subclassOf: UILabel.self).contains { $0.text == text }
        })

        if tableViewCell == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find cell containing text '\(text)'.", file: file, line: line)
        }
        return tableViewCell
    }

    public func tapCell(containingText text: String, file: StaticString = #filePath, line: UInt = #line) throws {
        guard
            let tableView = tableView,
            let tableViewCell = try cell(containingText: text),
            let indexPath = tableView.indexPath(for: tableViewCell)
        else { return }

        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }

    private func failOrRaise(_ message: String, file: StaticString, line: UInt) throws {
        switch failureBehavior {
        case .failTest:
            XCTFail(message, file: file, line: line)
        case .raiseException:
            throw RukaError.unfoundElement
        case .doNothing:
            break
        }
    }
}
