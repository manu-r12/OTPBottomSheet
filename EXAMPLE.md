# Example Usage

This example shows how to create an Apple Maps-like experience with a bottom sheet over a map view.

## Basic Usage

### 1. Create Bottom Sheet Instance
```swift
class MapViewController: UIViewController {
    private let bottomSheet = CustomBottomSheet()
}
```

### 2. Present SwiftUI Content
```swift
let todoApp = TodoAppView()
bottomSheet.present(content: todoApp, on: self)
```

### 3. Configure Positions
```swift
let config = BottomSheetConfiguration(
    initialPosition: .tip,
    supportedPositions: [.tip, .half, .full]
)
bottomSheet.present(content: myView, on: self, configuration: config)
```

## Advanced Features

### Dynamic Content Updates
```swift
// Update content without dismissing
bottomSheet.updateContent(newView, animated: true)

// Move to different position
bottomSheet.moveToPosition(.tip, animated: true)
```

### Position Change Delegate
```swift
extension MyViewController: BottomSheetDelegate {
    func bottomSheetDidChangePosition(_ position: BottomSheetPosition) {
        switch position {
        case .tip:
            // More map visible
        case .half:
            // Balanced view
        case .full:
            // Less map visible
        }
    }
}
```

## Map + List Example

The demo app shows:
1. **Full screen map** with floating controls
2. **List view** in bottom sheet
3. **Tap list item** → Sheet moves to tip position for better map visibility
4. **Smooth transitions** between all states

This pattern works great for:
- Maps with location details
- Photo galleries with info panels
- Music players with now playing info
- Any content that benefits from variable visibility