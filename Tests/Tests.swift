@testable import Ruka
import XCTest

class Tests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: UILabel

    func test_findsALabel() throws {
        let controller = RootViewController()
        let app = App(controller: controller)

        let label = try app.label(text: "Label text")
        XCTAssertNotNil(label)
        XCTAssertEqual(label?.superview?.superview, controller.view)
    }

    func test_doesNotFindAHiddenLabel() throws {
        let app = App(controller: RootViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.label(text: "Hidden label text"))
    }

    // MARK: UIButton

    func test_findsAButton() throws {
        let controller = RootViewController()
        let app = App(controller: controller)

        let button = try app.button(title: "Button title")
        XCTAssertNotNil(button)
        XCTAssertEqual(button?.superview?.superview, controller.view)
    }

    func test_doesNotFindAHiddenButton() throws {
        let controller = RootViewController()
        let app = App(controller: controller, failureBehavior: .doNothing)

        XCTAssertNil(try app.button(title: "Hidden button title"))
    }

    func test_tapsAButton() throws {
        let controller = RootViewController()
        let app = App(controller: controller)

        let button = try app.button(title: "Button title")
        button?.tap()

        _ = try app.label(text: "Changed label text")
    }

    func test_doesNotTapADisabledButton() throws {
        let controller = RootViewController()
        let app = App(controller: controller, failureBehavior: .doNothing)

        let button = try app.button(title: "Disabled button title")
        button?.tap()

        XCTAssertNil(try app.label(text: "Changed label text"))
    }

    // MARK: UINavigationController

    func test_pushesAViewController() throws {
        let navigationController = UINavigationController(rootViewController: RootViewController())
        let app = App(controller: navigationController)

        try app.button(title: "Push view controller")?.tap()

        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }

    func test_popsAViewController() throws {
        let navigationController = UINavigationController(rootViewController: RootViewController())
        let app = App(controller: navigationController)

        try app.button(title: "Push view controller")?.tap()
        XCTAssertEqual(navigationController.viewControllers.count, 2)

        try app.button(title: "Pop view controller")?.tap()
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    // MARK: Modal view controllers

    func test_presentsAViewController() throws {
        let controller = RootViewController()
        let app = App(controller: controller)

        try app.button(title: "Present view controller")?.tap()

        XCTAssertNotNil(controller.presentedViewController)
    }

    func test_dismissesAViewController() throws {
        let controller = RootViewController()
        let app = App(controller: controller)

        try app.button(title: "Present view controller")?.tap()
        XCTAssertNotNil(controller.presentedViewController)
        XCTAssertNotNil(app.controller.presentingViewController)

        try app.button(title: "Dismiss view controller")?.tap()
        XCTAssertNil(controller.presentedViewController)
        XCTAssertNil(app.controller.presentingViewController)
    }

    // MARK: Failure behavior

    func test_aMissingElement_raisesAnError() throws {
        let app = App(controller: RootViewController(), failureBehavior: .raiseException)
        XCTAssertThrowsError(try app.label(text: "Missing element"))
    }

    func test_aMissingElement_isNil() throws {
        let app = App(controller: RootViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.label(text: "Missing element"))
    }
}
