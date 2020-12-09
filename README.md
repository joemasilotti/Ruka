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

## View finders

### `UILabel`

`label(text:)` - find a non-hidden label with the given `text`, recursively, in the view

### `UIButton`

`button(title:)` - find a non-hidden button with the given `title`, recursively, in the view

### `UISwitch`

`switch(accessibilityLabel:)` - find a non-hidden switch with the given `accessibilityLabel`, recursively, in the view

### `UIStepper`

`stepper(accessibilityLabel:)` - finds a non-hidden stepper with the given `accessibilityLabel`, recursively, in the view

### `UITableView`

`app.cell(containingText: "Cell text")` - finds the first `UITableViewCell` (or subclass) containing a label matching the text

## Interactions

### `tap()`

`button.tap()` - triggers the target-action for the button if not disabled

### `toggle()`

`switch.toggle()` - triggers the value changed action on the switch if not disabled

### `tapCell(containingText:)`

`app.tapCell(containingText: "Cell text")` - taps the found cell (above) via its index path and delegate

### `incrementStepper()` and `decrementStepper()`

* `app.incrementStepper(accessibilityLabel:)` - increments the stepper by the step value and triggers the value changed action, if not disabled
* `app.decrementStepper(accessibilityLabel:)` - decrements the stepper by the step value and triggers the value changed action, if not disabled

## View controllers

Pushing/popping and presenting/dismissing view controllers is supported.

## `UIAlertController`

`app.alertViewController.tapButton(title: "Dismiss")` - triggers the attached action and dismisses the alert

## To-do

1. Sliders
1. Text fields
1. Gestures - swiping and scrolling
1. Collection views
1. Map views
1. ...

## Out of scope (for now)

1. System alerts - this probably isn't be possible
1. SwiftUI - [ViewInspector](https://github.com/nalexn/ViewInspector) is probably a better choice
