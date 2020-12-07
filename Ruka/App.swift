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

    private let failureBehavior: FailureBehavior
    private let window = UIWindow()

    private var controller: UIViewController! {
        if let navigationController = window.rootViewController as? UINavigationController {
            return navigationController.topViewController
        }
        return window.rootViewController
    }

    public init(failureBehavior: FailureBehavior = .failTest) {
        self.failureBehavior = failureBehavior
    }

    public mutating func load(controller: UIViewController) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
        self.controller.loadViewIfNeeded()
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
