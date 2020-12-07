import Ruka
import XCTest

class Tests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: UILabel

    func test_findsALabel() throws {
        var app = App()
        let controller = RootViewController()
        app.load(controller: controller)

        let label = try app.label(text: "Label text")
        XCTAssertNotNil(label)
        XCTAssertEqual(label?.superview?.superview, controller.view)
    }

    func test_doesNotFindAHiddenLabel() throws {
        var app = App(failureBehavior: .doNothing)
        let controller = RootViewController()
        app.load(controller: controller)

        XCTAssertNil(try app.label(text: "Hidden label text"))
    }

    // MARK: UIButton

    func test_findsAButton() throws {
        var app = App()
        let controller = RootViewController()
        app.load(controller: controller)

        let button = try app.button(title: "Button title")
        XCTAssertNotNil(button)
        XCTAssertEqual(button?.superview?.superview, controller.view)
    }

    func test_doesNotFindAHiddenButton() throws {
        var app = App(failureBehavior: .doNothing)
        let controller = RootViewController()
        app.load(controller: controller)

        XCTAssertNil(try app.button(title: "Hidden button title"))
    }

    func test_tapsAButton() throws {
        var app = App()
        let controller = RootViewController()
        app.load(controller: controller)

        let button = try app.button(title: "Button title")
        button?.tap()

        _ = try app.label(text: "Changed label text")
    }

    func test_doesNotTapADisabledButton() throws {
        var app = App(failureBehavior: .doNothing)
        let controller = RootViewController()
        app.load(controller: controller)

        let button = try app.button(title: "Disabled button title")
        button?.tap()

        XCTAssertNil(try app.label(text: "Changed label text"))
    }

    // MARK: Failure behavior

    func test_aMissingElement_raisesAnError() throws {
        var app = App(failureBehavior: .raiseException)
        let controller = RootViewController()
        app.load(controller: controller)

        XCTAssertThrowsError(try app.label(text: "Missing element"))
    }

    func test_aMissingElement_isNil() throws {
        var app = App(failureBehavior: .doNothing)
        let controller = RootViewController()
        app.load(controller: controller)

        XCTAssertNil(try app.label(text: "Missing element"))
    }
}
