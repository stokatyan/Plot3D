# Plot3D

[![Version](https://img.shields.io/cocoapods/v/ScrollCounter.svg?style=flat)](https://cocoapods.org/pods/Plot3d)
[![License](https://img.shields.io/cocoapods/l/ScrollCounter.svg?style=flat)](https://cocoapods.org/pods/Plot3d)
[![Platform](https://img.shields.io/cocoapods/p/ScrollCounter.svg?style=flat)](https://cocoapods.org/pods/Plot3d)

## Installation
Plot3d is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:
```ruby
pod 'Plot3d'
```

## Usage

### Single Digits
<img src="https://github.com/stokatyan/ReadMeMedia/blob/master/Plot3d/PlotView-0.gif"/>
A scene for a 3d plot can be created and added to a `UIViewController much like a standard `UIView`:

```swift
/// Initialize a view containing a 3-D plot with the given frame and a default configuration.
let plotView = PlotView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height),
                        configuration: PlotConfiguration())
/// Add `plotView` as a subview of the `UIViewController`'s view.
view.addSubview(plotView)
```
