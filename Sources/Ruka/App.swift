import XCTest

public struct App {
    public enum FailureBehavior {
        case failTest
        case raiseException
        case doNothing
    }

    public init(controller: UIViewController, failureBehavior: FailureBehavior = .failTest) {
        self.failureBehavior = failureBehavior

        load(controller: controller)
    }

    public init(storyboard: String, identifier: String, failureBehavior: FailureBehavior = .failTest) {
        self.failureBehavior = failureBehavior

        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        load(controller: controller)
    }

    // MARK: UILabel

    public func label(_ identifier: String, file: StaticString = #filePath, line: UInt = #line) throws -> UILabel? {
        let labels = controller.view.findViews(subclassOf: UILabel.self)
        let label = labels.first(where: { $0.isIdentifiable(by: identifier, in: controller) })

        if label == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find label with text '\(identifier)'.", file: file, line: line)
        }
        return label
    }

    // MARK: UIButton

    public func button(_ identifier: String, file: StaticString = #filePath, line: UInt = #line) throws -> UIButton? {
        let buttons = controller.view.findViews(subclassOf: UIButton.self)
        let button = buttons.first(where: { $0.isIdentifiable(by: identifier, in: controller) })

        if button == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find button with text '\(identifier)'.", file: file, line: line)
        }
        return button
    }

    public func tapButton(title: String, file: StaticString = #filePath, line: UInt = #line) throws {
        guard let button = try button(title: title), button.isEnabled else { return }

        let windowBeforeTap = window
        button.sendActions(for: .touchUpInside)

        // Controller containing button is being popped off of navigation stack, wait for animation.
        let timeInterval: Animation.Length = windowBeforeTap != button.window ? .popController : .short
        RunLoop.main.run(until: Date().addingTimeInterval(timeInterval.rawValue))
    }

    // MARK: UITableView

    public var tableView: UITableView? {
        controller.view.findViews(subclassOf: UITableView.self).first
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

    // MARK: UISwitch

    public func `switch`(_ identifier: String, file: StaticString = #filePath, line: UInt = #line) throws -> UISwitch? {
        let switches = controller.view.findViews(subclassOf: UISwitch.self)
        let `switch` = switches.first(where: { $0.isIdentifiable(by: identifier, in: controller) })

        if `switch` == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find switch with accessibility label '\(identifier)'.", file: file, line: line)
        }
        return `switch`
    }

    // MARK: UIStepper

    public func stepper(_ identifier: String, file: StaticString = #filePath, line: UInt = #line) throws -> UIStepper? {
        let steppers = controller.view.findViews(subclassOf: UIStepper.self)
        let stepper = steppers.first(where: { $0.isIdentifiable(by: identifier, in: controller) })

        if stepper == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find stepper with accessibility label '\(identifier)'.", file: file, line: line)
        }
        return stepper
    }

    // MARK: UISlider

    public func slider(_ identifier: String, file: StaticString = #filePath, line: UInt = #line) throws -> UISlider? {
        let sliders = controller.view.findViews(subclassOf: UISlider.self)
        let slider = sliders.first(where: { $0.isIdentifiable(by: identifier, in: controller) })

        if slider == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find slider with accessibility label '\(identifier)'.", file: file, line: line)
        }
        return slider
    }

    // MARK: UITextField

    public func textField(_ identifier: String, file: StaticString = #filePath, line: UInt = #line) throws -> UITextField? {
        let textFields = controller.view.findViews(subclassOf: UITextField.self)
        let textField = textFields.first(where: { $0.isIdentifiable(by: identifier, in: controller) })

        if textField == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find text field with placeholder '\(identifier)'.", file: file, line: line)
        }
        return textField
    }

    // MARK: UIAlertController

    public var alertViewController: UIAlertController? {
        controller as? UIAlertController
    }

    // MARK: Private

    private enum RukaError: Error {
        case unfoundElement
    }

    private let failureBehavior: FailureBehavior
    private let window = UIWindow()
    private var controller: UIViewController! { visibleViewController(from: window.rootViewController) }

    private func load(controller: UIViewController) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        controller.view.layoutIfNeeded()
    }

    private func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return visibleViewController(from: navigationController.topViewController)
        }

        if let tabBarController = viewController as? UITabBarController {
            return visibleViewController(from: tabBarController.selectedViewController)
        }

        if let presentedViewController = viewController?.presentedViewController {
            return visibleViewController(from: presentedViewController)
        }

        return viewController

    private func viewIsVisibleInController(_ view: UIView) -> Bool {
        view.frame.intersects(controller.view.bounds)
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
