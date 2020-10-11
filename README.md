# BottomSheet
Bottom sheet popover built with Swift & UIKit

<p align="center">  
    <img src = "Assets/Logo.png" /> <br>
    <img src = "https://img.shields.io/badge/platform-iOS%2011.0%2B-lightgrey" />
    <img src = "https://img.shields.io/badge/swift-5.0-orange.svg" />
    <img src = "https://img.shields.io/badge/cocoapods-✔-green.svg" />
    <img src = "https://img.shields.io/badge/license-MIT-blue.svg" />
</p>

## Installation

### CocoaPods
[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. To integrate BottomSheet into your project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'IDBottomSheet'
```
After that use `pod install` command in your terminal.

### Manually
If you prefer not to use any dependency managers, you can integrate BottomSheet into your project manually by downloading the desired release and copying the `Sources` directory.

## Usage

### Creation
Subclass `BottomSheetViewController`, then override viewDidLoad like this:
```swift
class ViewController: BottomSheetViewController {
    override func viewDidLoad() {
        viewController = BottomSheetContentsViewController() //your view controller
        isHalfPresentationEnabled = true //or false
        super.viewDidLoad()
    }
}
```
Note that `super.viewDidLoad()` must be called after you set BottomSheetViewController properties.

### Enable Half Presentation
To enable half presentation set `isHalfPresentationEnabled` property to `true`.
<table  align="center">
	<tr>
		<th>isHalfPresentationEnabled = false</th>
		<th>isHalfPresentationEnabled = true</th>
 	</tr>
 	<tr>
  		<td><img src = "Assets/Demo.gif" /></td>
   		<td><img src = "Assets/isHalfPresentationEnabledDemo.gif" /></td>
 	</tr>
</table>

### Animation Duration
To change animation duration set `animationDuration` property.

### Popover Start & End Height
To modify popover startHeight & endHeight call `setupSizeWith(startHeight: CGFloat, endHeight: CGFloat)` method.

### Popover Corner Radius
To modify popover corner radius for all states call `setupCornerRadiusForState(collapsed: CGFloat, halfPresented: CGFloat, expanded: CGFloat)` method.
To modify popover corner radius for a single state call `setupCornerRadiusForState(state: State, value: CGFloat)` method.

## Behaviour
BottomSheet recognizes taps on the handler and recognizes swipes across the entire view.
In addition, BottomSheet analyzes how fast you swipe and where you swipe. This means that if you swipe slowly and the swipe endpoint is less than half of the popup's height, the presentation will be canceled. If you swipe quickly, the popup will always be presented.

## Example
This repository contains example where you can [see how](Example/ViewController.swift) BottomSheet can be used for presenting Apple Music player popover.

## License
BottomSheet is available under the MIT license, see the [LICENSE](LICENSE) file for more information.
