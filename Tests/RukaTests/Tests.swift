import Ruka
import XCTest

class Tests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // MARK: Storyboard

    func test_findsAStoryboardBackedController() throws {
        let app = App(storyboard: "Main", identifier: "UIViewController identifier")
        XCTAssertNotNil(try app.label("Storyboard label text"))
    }

    // MARK: UILabel

    func test_findsALabel() throws {
        let controller = RootViewController()
        let app = App(controller: controller)

        let label = try app.label("Label text")
        XCTAssertNotNil(label)
        XCTAssertEqual(label?.superview?.superview, controller.view)
    }

    func test_findsALabelViaTheAccessibilityLabel() throws {
        let app = App(controller: RootViewController())
        XCTAssertNotNil(try app.label("a11y labeled label"))
    }

    func test_findsALabelViaTheAccessibilityIdentifier() throws {
        let app = App(controller: RootViewController())
        XCTAssertNotNil(try app.label("a11y identified label"))
    }

    func test_doesNotFindAHiddenLabel() throws {
        let app = App(controller: RootViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.label("Hidden label text"))
    }

    func test_doesNotFindALabelOffTheScreen() throws {
        let app = App(controller: RootViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.label("Off screen label text"))
    }

    // MARK: UIButton

    func test_findsAButton() throws {
        let controller = RootViewController()
        let app = App(controller: controller)

        let button = try app.button("Button title")
        XCTAssertNotNil(button)
        XCTAssertEqual(button?.superview?.superview, controller.view)
    }

    func test_findsAButtonViaTheAccessibilityLabel() throws {
        let app = App(controller: RootViewController())
        XCTAssertNotNil(try app.button("a11y labeled button"))
    }

    func test_findsAButtonViaTheAccessibilityIdentifier() throws {
        let app = App(controller: RootViewController())
        XCTAssertNotNil(try app.button("a11y identified button"))
    }

    func test_doesNotFindAHiddenButton() throws {
        let controller = RootViewController()
        let app = App(controller: controller, failureBehavior: .doNothing)

        XCTAssertNil(try app.button("Hidden button title"))
    }

    func test_doesNotFindAButtonOffTheScreen() throws {
        let app = App(controller: RootViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.button("Off screen button title"))
    }

    func test_tapsAButton() throws {
        let controller = RootViewController()
        let app = App(controller: controller)

        try app.tapButton(title: "Button title")

        _ = try app.label("Changed label text")
    }

    func test_doesNotTapADisabledButton() throws {
        let controller = RootViewController()
        let app = App(controller: controller, failureBehavior: .doNothing)

        try app.tapButton(title: "Disabled button title")

        XCTAssertNil(try app.label("Changed label text"))
    }

    // MARK: UINavigationController

    func test_pushesAViewController() throws {
        let navigationController = UINavigationController(rootViewController: RootViewController())
        let app = App(controller: navigationController)

        try app.tapButton(title: "Push view controller")

        XCTAssertEqual(navigationController.viewControllers.count, 2)
    }

    func test_popsAViewController() throws {
        let navigationController = UINavigationController(rootViewController: RootViewController())
        let app = App(controller: navigationController)

        try app.tapButton(title: "Push view controller")
        XCTAssertEqual(navigationController.viewControllers.count, 2)

        try app.tapButton(title: "Pop view controller")
        XCTAssertEqual(navigationController.viewControllers.count, 1)
    }

    // MARK: Modal view controllers

    func test_presentsAViewController() throws {
        let controller = RootViewController()
        let app = App(controller: controller)

        try app.tapButton(title: "Present view controller")

        XCTAssertNotNil(controller.presentedViewController)
    }

    func test_dismissesAViewController() throws {
        let controller = RootViewController()
        let app = App(controller: controller, failureBehavior: .doNothing)
        XCTAssertNil(try app.button("Dismiss view controller"))

        try app.tapButton(title: "Present view controller")
        XCTAssertNotNil(try app.button(title: "Dismiss view controller"))

        try app.tapButton(title: "Dismiss view controller")
        XCTAssertNil(try app.button(title: "Dismiss view controller"))
    }
    
    func test_dismissNestedModalViewController() throws {
        let controller = RootViewController()
        let app = App(controller: controller, failureBehavior: .doNothing)
        XCTAssertNil(try app.button(title: "Dismiss view controller"))

        try app.tapButton(title: "Present view controller")
        XCTAssertNotNil(try app.button(title: "Dismiss view controller"))
        
        try app.tapButton(title: "Present view controller")
        XCTAssertNotNil(try app.button(title: "Dismiss view controller"))

        try app.tapButton(title: "Dismiss view controller")
        XCTAssertNotNil(try app.button(title: "Dismiss view controller"))
        
        try app.tapButton(title: "Dismiss view controller")
        XCTAssertNil(try app.button(title: "Dismiss view controller"))
    }
    
    // MARK: UITabBarController
    
    func test_presentsAViewControllerOnSecondTabInTabBarController() throws {
        let tabBarController = TabBarViewController()
        let app = App(controller: tabBarController, failureBehavior: .doNothing)
        XCTAssertNil(try app.button(title: "Present view controller from second tab"))

        tabBarController.selectedIndex = 1
        XCTAssertNotNil(try app.button(title: "Present view controller from second tab"))
        try app.tapButton(title: "Present view controller from second tab")
        
        XCTAssertNotNil(tabBarController.secondTabViewController.presentedViewController)
    }

    // MARK: UIAlertController

    func test_findsAnAlert() throws {
        let controller = RootViewController()
        let app = App(controller: controller)

        try app.tapButton(title: "Show alert")
        XCTAssertNotNil(try app.label(text: "Alert title"))
        XCTAssertNotNil(try app.label(text: "Alert message."))
    }

    func test_dismissesAnAlert() throws {
        let controller = RootViewController()
        let app = App(controller: controller, failureBehavior: .doNothing)

        try app.tapButton(title: "Show alert")
        XCTAssertNil(try app.button(title: "Show alert"))

        app.alertViewController?.tapButton(title: "Dismiss")
        XCTAssertNotNil(try app.button("Show alert"))
        XCTAssertNotNil(try app.label("Changed label text"))
    }

    // MARK: UITableView

    func test_findsVisibleCells() throws {
        let app = App(controller: TableViewController())
        XCTAssertEqual(app.tableView?.visibleCells.count ?? 0, 3)
    }

    func test_findsASpecificCell() throws {
        let app = App(controller: TableViewController(), failureBehavior: .doNothing)
        XCTAssertNotNil(try app.cell(containingText: "Three"))

        XCTAssertNotNil(try app.label("Label text"))
        XCTAssertNil(try app.cell(containingText: "Label text"))
    }

    func test_tapsACell() throws {
        let app = App(controller: TableViewController())
        try app.cell(containingText: "Three")?.tap()
        XCTAssertNotNil(try app.label("Changed label text"))
    }

    // MARK: UISwitch

    func test_findsASwitchViaTheAccessibilityLabel() throws {
        let app = App(controller: FormViewController())
        XCTAssertNotNil(try app.switch("a11y labeled switch"))
    }

    func test_findsASwitchViaTheAccessibilityIdentifier() throws {
        let app = App(controller: FormViewController())
        XCTAssertNotNil(try app.switch("a11y identified switch"))
    }

    func test_doesNotFindAHiddenSwitch() throws {
        let app = App(controller: FormViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.switch("A hidden switch"))
    }

    func test_doesNotFindASwitchOffTheScreen() throws {
        let app = App(controller: FormViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.switch("An off screen switch"))
    }

    func test_togglesASwitch() throws {
        let app = App(controller: FormViewController())
        let `switch` = try app.switch("A switch")
        XCTAssertNotNil(try app.label("Disabled"))

        `switch`?.toggle()
        XCTAssertNotNil(try app.label("Enabled"))
    }

    func test_doesNotToggleADisabledSwitch() throws {
        let app = App(controller: FormViewController())
        let `switch` = try app.switch("A disabled switch")
        XCTAssertNotNil(try app.label("Disabled"))

        `switch`?.toggle()
        XCTAssertNotNil(try app.label("Disabled"))
    }

    // MARK: UIStepper

    func test_findsAStepperViaTheAccessibilityLabel() throws {
        let app = App(controller: FormViewController())
        XCTAssertNotNil(try app.stepper("a11y labeled stepper"))
    }

    func test_findsAStepperViaTheAccessibilityIdentifier() throws {
        let app = App(controller: FormViewController())
        XCTAssertNotNil(try app.stepper("a11y identified stepper"))
    }

    func test_doesNotFindAHiddenStepper() throws {
        let app = App(controller: FormViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.stepper("A hidden stepper"))
    }

    func test_doesNotFindAStepperOffTheScreen() throws {
        let app = App(controller: FormViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.stepper("An off screen stepper"))
    }

    func test_incrementsAStepper() throws {
        let app = App(controller: FormViewController())
        try app.stepper("A stepper")?.increment()
        XCTAssertNotNil(try app.label("3.0"))
    }

    func test_decrementsAStepper() throws {
        let app = App(controller: FormViewController())
        try app.stepper("A stepper")?.decrement()
        XCTAssertNotNil(try app.label("1.0"))
    }

    func test_doesNotIncrementADisabledStepper() throws {
        let app = App(controller: FormViewController())
        try app.stepper("A disabled stepper")?.increment()
        XCTAssertNotNil(try app.label("2.0"))
    }

    func test_doesNotDecrementADisabledStepper() throws {
        let app = App(controller: FormViewController())
        try app.stepper("A disabled stepper")?.decrement()
        XCTAssertNotNil(try app.label("2.0"))
    }

    // MARK: UISlider

    func test_findsASliderViaTheAccessibilityLabel() throws {
        let app = App(controller: FormViewController())
        XCTAssertNotNil(try app.slider("a11y labeled slider"))
    }

    func test_findsASliderViaTheAccessibilityIdentifier() throws {
        let app = App(controller: FormViewController())
        XCTAssertNotNil(try app.slider("a11y identified slider"))
    }

    func test_doesNotFindAHiddenSlider() throws {
        let app = App(controller: FormViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.slider("A hidden slider"))
    }

    func test_doesNotFindASliderOffTheScreen() throws {
        let app = App(controller: FormViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.slider("An off screen slider"))
    }

    func test_setsASlidersValue() throws {
        let app = App(controller: FormViewController())
        try app.slider("A slider")?.set(value: 30)
        XCTAssertNotNil(try app.label("30.0"))
    }

    func test_doesNotSetADisabledSlidersValue() throws {
        let app = App(controller: FormViewController())
        try app.slider("A disabled slider")?.set(value: 30)
        XCTAssertNotNil(try app.label("20.0"))
    }

    // MARK: UITextField

    func test_findsATextFieldViaThePlaceholder() throws {
        let app = App(controller: FormViewController())
        XCTAssertNotNil(try app.textField("Text field placeholder"))
    }

    func test_findsATextFieldViaTheAccessibilityLabel() throws {
        let app = App(controller: FormViewController())
        XCTAssertNotNil(try app.textField("a11y labeled text field"))
    }

    func test_findsATextFieldViaTheAccessibilityIdentifier() throws {
        let app = App(controller: FormViewController())
        XCTAssertNotNil(try app.textField("a11y identified text field"))
    }

    func test_doesNotFindAHiddenTextField() throws {
        let app = App(controller: FormViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.textField("Hidden text field placeholder"))
    }

    func test_doesNotFindATextFieldOffTheScreen() throws {
        let app = App(controller: FormViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.textField("Off screen text field placeholder"))
    }

    func test_typesIntoATextField() throws {
        let app = App(controller: FormViewController())
        let textField = try app.textField("Text field placeholder")

        textField?.type(text: "Some typed text.")
        XCTAssertEqual(textField?.text, "Some typed text.")
        XCTAssertNotNil(try app.label("Some typed text."))
    }

    func test_doesNotTypeIntoADisabledTextField() throws {
        let app = App(controller: FormViewController(), failureBehavior: .doNothing)
        let textField = try app.textField("Disabled text field placeholder")

        textField?.type(text: "Some typed text.")
        XCTAssertEqual(textField?.text, "")
        XCTAssertNil(try app.label("Some typed text."))
    }

    // MARK: Failure behavior

    func test_aMissingElement_raisesAnError() throws {
        let app = App(controller: RootViewController(), failureBehavior: .raiseException)
        XCTAssertThrowsError(try app.label("Missing element"))
    }

    func test_aMissingElement_isNil() throws {
        let app = App(controller: RootViewController(), failureBehavior: .doNothing)
        XCTAssertNil(try app.label("Missing element"))
    }
}
