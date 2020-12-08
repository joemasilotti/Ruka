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

let app = App()
let controller = /* your controller */
app.load(controller: controller)

// ...
```

See the unit tests for more examples.

## View finders

### `UILabel`

`label(text:)` - find a non-hidden label with the given `text`, recursively, in the view

### `UIButton`

`button(title:)` - find a non-hidden button with the given `title`, recursively, in the view

## Interactions

### `tap()`

`button.tap()` - triggers the target-action for the button if not disabled

## View controllers

Pushing/popping and presenting/dismissing view controllers is supported.

## `UIAlertController`

`app.alertViewController.tapButton(title: "Dismiss")` - triggers the attached action and dismisses the alert

## To-do

1. Table views
1. Collection views
1. Text fields
1. (probably a lot more!)

## Out of scope (for now)

1. System alerts - this probably isn't be possible
1. SwiftUI - [ViewInspector](https://github.com/nalexn/ViewInspector) is probably a better choice
