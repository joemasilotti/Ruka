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

    public func label(text: String, file: StaticString = #filePath, line: UInt = #line) throws -> UILabel? {
        let labels = controller.view.findViews(subclassOf: UILabel.self)
        let label = labels.first(where: { $0.text == text && !$0.isHidden && viewIsVisibleInController($0) })

        if label == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find label with text '\(text)'.", file: file, line: line)
        }
        return label
    }

    // MARK: UIButton

    public func button(title: String, file: StaticString = #filePath, line: UInt = #line) throws -> UIButton? {
        let buttons = controller.view.findViews(subclassOf: UIButton.self)
        let button = buttons.first(where: { $0.title(for: .normal) == title && !$0.isHidden && viewIsVisibleInController($0) })

        if button == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find button with text '\(title)'.", file: file, line: line)
        }
        return button
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

    public func `switch`(accessibilityLabel label: String, file: StaticString = #filePath, line: UInt = #line) throws -> UISwitch? {
        let switches = controller.view.findViews(subclassOf: UISwitch.self)
        let `switch` = switches.first(where: { $0.accessibilityLabel == label && !$0.isHidden && viewIsVisibleInController($0) })

        if `switch` == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find switch with accessibility label '\(label)'.", file: file, line: line)
        }
        return `switch`
    }

    // MARK: UIStepper

    public func stepper(accessibilityLabel label: String, file: StaticString = #filePath, line: UInt = #line) throws -> UIStepper? {
        let steppers = controller.view.findViews(subclassOf: UIStepper.self)
        let stepper = steppers.first(where: { $0.accessibilityLabel == label && !$0.isHidden && viewIsVisibleInController($0) })

        if stepper == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find stepper with accessibility label '\(label)'.", file: file, line: line)
        }
        return stepper
    }

    public func incrementStepper(accessibilityLabel label: String, file: StaticString = #filePath, line: UInt = #line) throws {
        guard
            let stepper = try self.stepper(accessibilityLabel: label, file: file, line: line),
            stepper.isEnabled
        else { return }

        stepper.value += stepper.stepValue
        stepper.sendActions(for: .valueChanged)
    }

    public func decrementStepper(accessibilityLabel label: String, file: StaticString = #filePath, line: UInt = #line) throws {
        guard
            let stepper = try self.stepper(accessibilityLabel: label, file: file, line: line),
            stepper.isEnabled
        else { return }

        stepper.value -= stepper.stepValue
        stepper.sendActions(for: .valueChanged)
    }

    // MARK: UISlider

    public func slider(accessibilityLabel label: String, file: StaticString = #filePath, line: UInt = #line) throws -> UISlider? {
        let sliders = controller.view.findViews(subclassOf: UISlider.self)
        let slider = sliders.first(where: { $0.accessibilityLabel == label && !$0.isHidden && viewIsVisibleInController($0) })

        if slider == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find slider with accessibility label '\(label)'.", file: file, line: line)
        }
        return slider
    }

    public func setSlider(accessibilityLabel label: String, value: Float, file: StaticString = #filePath, line: UInt = #line) throws {
        guard
            let slider = try self.slider(accessibilityLabel: label, file: file, line: line),
            slider.isEnabled
        else { return }

        slider.setValue(value, animated: false)
        slider.sendActions(for: .valueChanged)
    }

    // MARK: UITextField

    public func textField(placeholder: String, file: StaticString = #filePath, line: UInt = #line) throws -> UITextField? {
        let textFields = controller.view.findViews(subclassOf: UITextField.self)
        let textField = textFields.first(where: { $0.placeholder == placeholder && !$0.isHidden && viewIsVisibleInController($0) })

        if textField == nil, failureBehavior != .doNothing {
            try failOrRaise("Could not find text field with placeholder '\(placeholder)'.", file: file, line: line)
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

    private var controller: UIViewController! {
        if let navigationController = window.rootViewController as? UINavigationController {
            return navigationController.topViewController
        } else if let presentedController = window.rootViewController?.presentedViewController {
            return presentedController
        }
        return window.rootViewController
    }

    private func load(controller: UIViewController) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
        controller.loadViewIfNeeded()
        controller.view.layoutIfNeeded()
    }

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
