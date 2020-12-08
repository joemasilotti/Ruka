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

    public func `switch`(accessibilityLabel label: String, file: StaticString = #filePath, line: UInt = #line) throws -> UISwitch? {
        let switches = controller.view.findViews(subclassOf: UISwitch.self)
        let `switch` = switches.first(where: { $0.accessibilityLabel == label && !$0.isHidden })

        if `switch` == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find switch with accessibility label '\(label)'.", file: file, line: line)
        }
        return `switch`
    }

    public func stepper(accessibilityLabel label: String, file: StaticString = #filePath, line: UInt = #line) throws -> UIStepper? {
        let steppers = controller.view.findViews(subclassOf: UIStepper.self)
        let stepper = steppers.first(where: { $0.accessibilityLabel == label && !$0.isHidden })

        if stepper == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find stepper with accessibility label '\(label)'.", file: file, line: line)
        }
        return stepper
    }

    public func incrementStepper(accessibilityLabel label: String, file: StaticString = #filePath, line: UInt = #line) throws {
        guard let stepper = try self.stepper(accessibilityLabel: label), stepper.isEnabled else { return }
        stepper.value += stepper.stepValue
        stepper.sendActions(for: .valueChanged)
    }

    public func decrementStepper(accessibilityLabel label: String, file: StaticString = #filePath, line: UInt = #line) throws {
        guard let stepper = try self.stepper(accessibilityLabel: label), stepper.isEnabled else { return }
        stepper.value -= stepper.stepValue
        stepper.sendActions(for: .valueChanged)
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
