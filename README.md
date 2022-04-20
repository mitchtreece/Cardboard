<!-- ![Cardboard](Resources/banner.png) -->

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

Cardboard is a modal-card presentation & customization system built with speed and simplicity in mind

### Basic Usage

Getting started with Cardboard is dead simple:

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

        Card.default(CustomCardView())
            .present(from: self)

    }

}
```

You just make a custom content view, and present it!

### Customization

Cardboard comes with some built-in style options:

- **default**: a standard bottom slide-up card
- **system**: a card styled like the iOS 13 pop-up cards (i.e. AirPods nearby card)
- **notification**: a top slide-down notification card
- **toast**: a bottom slide-up toast card
- **alert**: a centered alert-style card.

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

You like one of the builin styles but want to slightly tweak it? Cardboard has you covered:

```swift
let view = CustomCardView()

Card.notification(view) { make in

    make.anchor = .bottom
    make.corners.roundedCornerRadius = 8

}
.present(from: self)
```

You can adjust almost every aspect of a card, right down to what kinds of interactions you want it to support 🎉

## Contributing
Pull-requests are more than welcome. Bug fix? Feature? Open a PR and we'll get it merged in!
