![Cardboard](Assets/Banner.png)

[![Version](https://img.shields.io/cocoapods/v/Cardboard.svg?style=for-the-badge)](http://cocoapods.org/pods/Cardboard)
![Swift](https://img.shields.io/badge/Swift-5-orange.svg?style=for-the-badge)
![iOS](https://img.shields.io/badge/iOS-13--15-green.svg?style=for-the-badge)
[![License](https://img.shields.io/cocoapods/l/Cardboard.svg?style=for-the-badge)](http://cocoapods.org/pods/Cardboard)

## Overview

Cardboard is a customizable modal-card library for iOS

## Installation

### CocoaPods
Cardboard is integrated with CocoaPods!

1. Add the following to your `Podfile`:
```
use_frameworks!
pod 'Cardboard', '~> 1.0'
```
2. In your project directory, run `pod install`
3. Import the `Cardboard` module wherever you need it
4. Profit

### Manually
You can also manually add the source files to your project

1. Clone this git repo
2. Add all the Swift files in the `Cardboard/` subdirectory to your project
3. Profit

## Cardboard

Cardboard is a modal-card presentation & customization system built with speed and simplicity in mind.

It's also the spiritual-successor of [Bulletin](https://github.com/mitchtreece/Bulletin)

### Basic Usage

Getting started with Cardboard is dead simple! All you need to do is make a custom card content view, and present it:

*CustomCardView.swift*
```swift
import UIKit
import Cardboard

class CustomCardView: CardContentView {
    ...
}
```

CustomViewController.swift
```swift
import UIKit
import Cardboard

class CustomViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        Card
            .defaultModal(CustomCardView())
            .present(from: self)

    }

}
```

### Customization

Cardboard comes with some built-in style options:

- **defaultModal**: a standard bottom slide-up card
- **system**: a card styled like the iOS 13 system "chip" cards (i.e. AirPods)
- **notification**: a top slide-down notification card
- **banner**: a top slide-down banner card
- **toast**: a bottom slide-up toast card
- **alert**: a centered alert-style card

But of course, the styling doesn't stop there! Cardboard has a robust customization system that you can abuse to your heart's content 🤪

```swift
let view = CustomCardView()

Card(view) { make in

    make.anchor = .top
    make.statusBar = .lightContent
    make.contentOverlay = .color(.black.withAlphaComponent(0.8))
    make.corners.roundedCornerRadius = 32

}
.present(from: self)
```

You like one of the built-in styles, but want to slightly tweak it? Cardboard has you covered:

```swift
let view = CustomCardView()

Card.notification(view) { make in

    make.anchor = .bottom
    make.corners.roundedCornerRadius = 8

}
.present(from: self)
```

You can adjust almost every aspect of a card, right down to what kinds of interactions you want it to support 🎉

## TODO
- **Card Presentation Levels**: As of now, all cards are presented from a *source* view controller. However, there are some situations where it would be more useful to present on something more "global" (i.e. at a window-level). This could be for something like presenting notification cards over an entire application - instead of just over a single view controller.

- **Card Queuing**: Right now, all cards are presented immediately without any context as to other cards / presentations. Instead of always presenting immediately, being able to "enqueue" a card for presentation would be helpful in several scenarios. For example, imagine presenting notification cards. You might only want one notification to be active at a time (this is how the iOS notification system works). Having a queuing system would allow us to achieve this.

## Contributing
Pull-requests are more than welcome. Bug fix? Feature? Open a PR and we'll get it merged in!
