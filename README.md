# BottomSheet
Simple bottom sheet popover built with Swift & UIKit

<p align="center">  
<img src = "Assets/Logo.png" />

## Installation

### Manually
If you prefer not to use any dependency managers, you can integrate TelegramColorPicker into your project manually by downloading the desired release and copying the `Sources` directory.

## Usage

### Creation
Subclass `BottomSheetViewController`, then override viewDidLoad like this:
```swift
override func viewDidLoad() {
    viewController = BottomSheetContentsViewController() //BottomSheetContentsViewController() is your view controller
    super.viewDidLoad()
}
```
Note that `super.viewDidLoad()` must be called after you set viewController property.

### Animation Duration
To change animation duration configure `animationDuration` property: `animationDuration = 0.5`.

### Popover Start & End Height
To modify popover startHeight & endHeight call `setupSizeWith(startHeight: CGFloat, endHeight: CGFloat)` function.

## Behaviour
BottomSheet recognizes taps on the handler and recognizes swipes across the entire view.

## Example
This repository contains example where you can [see how](Example/ViewController.swift) BottomSheet can be used for presenting Apple Music player popover.
<p align="center">  
<img src = "Assets/Demo.gif" />
</p>

## License
BottomSheet is available under the MIT license, see the [LICENSE](LICENSE) file for more information.
