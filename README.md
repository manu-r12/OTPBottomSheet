# OTP Bottom Sheet

A simple, customizable bottom sheet library for iOS that wraps FloatingPanel to provide seamless SwiftUI content integration in UIKit apps.

## Features

- 🎯 **Drop-in integration** - Just present any SwiftUI view
- 📱 **Apple Maps-like behavior** - Smooth transitions and positioning
- ⚙️ **Configurable positions** - Tip, half, and full detents
- 🔄 **Dynamic content updates** - Change content without dismissing
- 🎨 **SwiftUI + UIKit** - Best of both worlds

## Quick Start

1. Add FloatingPanel dependency to your project
2. Copy the `CustomBottomSheet.swift` file
3. Present any SwiftUI view:

```swift
let bottomSheet = CustomBottomSheet()
let myView = MySwiftUIView()
bottomSheet.present(content: myView, on: viewController)
```

## Example

This project demonstrates a map app with location list where tapping locations shows details in a bottom sheet that automatically adjusts position for optimal map visibility.

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Installation

1. Add FloatingPanel to your project via SPM:
   ```
   https://github.com/scenee/FloatingPanel
   ```

2. Add the CustomBottomSheet files to your project

## License

MIT License - see LICENSE file for details.