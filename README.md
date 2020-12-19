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

### Label

`let label = try app.label(text:)` - find a non-hidden label with the given `text`, recursively, in the view

### Button

 `try app.button(title:)` - find a non-hidden button with the given `title`, recursively, in the view
 
 `app.tapButton(title:)` - triggers the target-action for the non-hidden button with the given `title`, if not disabled

### Switch

`let aSwitch = try app.switch(accessibilityLabel:)` - find a non-hidden switch with the given `accessibilityLabel`, recursively, in the view

`aSwitch?.toggle()` - triggers the value changed action on the switch if not disabled

### Table cell

`let cell = try app.cell(containingText:)` - finds the first `UITableViewCell` (or subclass) containing a label matching the text

`cell?.tap()` - taps the cell via its index path and delegate

### Stepper

`try app.stepper(accessibilityLabel:)` - finds a non-hidden stepper with the given `accessibilityLabel`, recursively, in the view

 `app.incrementStepper(accessibilityLabel:)` - increments the stepper by the step value and triggers the value changed action, if not disabled
 
 `app.decrementStepper(accessibilityLabel:)` - decrements the stepper by the step value and triggers the value changed action, if not disabled

### Slider

`try app.slider(accessibilityLabel:)` - finds a non-hidden slider with the given `accessibilityLabel`, recursively, in the view

`setSlider(accessibilityLabel:value:)` - sets the slider to the value and triggers the value changed action, if not disabled

### Text fields

`let textField = try app.textField(placeholder:)` - finds a non-hidden text field with the given `placeholder`, recursively , in the view

 `textField?.type(text:)` - sets the text field's value and calls `textField(_:, shouldChangeCharactersIn:, replacementString:)` on the delegate, if not disabled

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
