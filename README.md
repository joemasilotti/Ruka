# UI tests without UI Testing experiment

This repo is a small experiment to see if there's an "in-between" for testing iOS applications. More feature-level than XCTest but not as heavy handed (or slow and brittle) as UI Testing.

The general idea is to provide an API similar to UI Testing but be able to spin up any controller on the fly. By putting the controller inside of a window the test behaves a bit more like the real app.

This extends on my thoughts in a recent blog, [Testing the UI without UI Testing in Swift](https://masilotti.com/testing-ui-without-ui-testing/).

## Is this crazy?

Probably! But maybe this is something worth exploring.

Have you tried anything like this? Is this obviously a maintenance nightmare? I would love to hear what you think.

## Setup

In your `XCTestCase` tests...

```swift
continueAfterFailure = false

// Code-powered views
let controller = SomeViewController()
let app = App(controller: controller)

// Storyboard-powered views
let controller = SomeViewController()
let app = App(storyboard: "Main", identifier: "Some identifier")

// ...
```

See the unit tests for more examples.

## API

First, create a reference to an `app` instance with your controller, as shown above.

The "top" view controller's view will be searched. For example, a controller pushed onto a navigation stack or presented modally.

The finders ignore views that are disabled or not in the controller's view's frame. For example, a view rendered off the screen cannot be found.

Interaction with elements is ignored if the element is disabled.

### Label

`let label = try app.label()` - find a label via `text` or accessibility label/identifier

### Button

`try app.button(title:)` - find a non-hidden button with the given `title`, recursively, in the view
 
`app.tapButton(title:)` - triggers the target-action for the non-hidden button with the given `title`, if not disabled

### Switch

`let aSwitch = try app.switch()` - find a switch via accessibility label/identifier

`aSwitch?.toggle()` - triggers the value changed action on the switch

### Table cell

`let cell = try app.cell(containingText:)` - find the first `UITableViewCell` (or subclass) containing a label matching the text

`cell?.tap()` - taps the cell via its index path and delegate

### Stepper

`let stepper = try app.stepper()` - find a stepper via accessibility label/identifier

 `stepper?.increment()` - increments the stepper by the step value and triggers the value changed action
 
 `stepper?.decrement()` - decrements the stepper by the step value and triggers the value changed action

### Slider

`let slider = try app.slider()` - find a slider via accessibility label/identifier

`slider?.set(value:)` - sets the slider to the value and triggers the value changed action

### Text fields

`let textField = try app.textField()` - find a text field via `placeholder` or accessibility label/identifier

 `textField?.type(text:)` - sets the text field's value and calls `textField(_:, shouldChangeCharactersIn:, replacementString:)` on the delegate

### Alerts

`app.alertViewController?.tapButton(title:)` - triggers the attached action and dismisses the alert

## To-do

1. Gesture - swiping and scrolling
1. Collection view
1. Map view
1. ...

## Out of scope (for now)

1. System alert - this probably isn't be possible
1. SwiftUI - [ViewInspector](https://github.com/nalexn/ViewInspector) is probably a better choice
