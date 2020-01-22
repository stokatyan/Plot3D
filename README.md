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
Plot3d is a framework for plotting data in 3d.  The data is plotted using SceneKit and the entire scene is contained in a PlotView, which is a subclass of a UIView.  A PlotView creates a 3d plot using a data source and delegate pattern similar to a UITableView's so, hopefully, it is easy to get started.

Checkout [this Medium article](https://medium.com/@tokat.shant/scrollcounter-an-ios-solution-to-the-robinhood-number-animation-bbcbd8c90355) for a more detailed example on how to use Plot3d.

### PlotView
<img src="https://github.com/stokatyan/ReadMeMedia/blob/master/Plot3d/PlotView-0.gif"/>
A scene for a 3d plot can be created and added to a view controller much using a PlotView.

```swift
/// Initialize a view containing a 3-D plot with the given frame and a default configuration.
let plotView = PlotView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height),
                        configuration: PlotConfiguration())
/// A PlotView is child of UIView, so add it as a subview.
view.addSubview(plotView)
```

### Plotting Points
<img src="https://github.com/stokatyan/ReadMeMedia/blob/master/Plot3d/PlotView-1.jpeg" width="250" height="294"/>
Points are plotted using a pattern similar to UITableView.

```swift
// A plot view delegates tasks similar to a UITableView.
plotView.dataSource = self
plotView.delegate = self
plotView.reloadData()

// Set the axis titles.
plotView.setAxisTitle(.x, text: "x axis", textColor: .white)
plotView.setAxisTitle(.y, text: "y axis", textColor: .white)
plotView.setAxisTitle(.z, text: "z axis", textColor: .white)
```
```swift
extension ViewController: PlotDataSource {
    func numberOfPoints() -> Int {
        return 16
    }
}

extension ViewController: PlotDelegate {

    func plot(_ plotView: PlotView, pointForItemAt index: Int) -> PlotPoint {
        let v = CGFloat(index)
        return PlotPoint(v, sqrt(v) * 3, v)
    }

    func plot(_ plotView: PlotView, geometryForItemAt index: Int) -> SCNGeometry? {
        let geo = SCNSphere(radius: 0.15)
        geo.materials.first!.diffuse.contents = UIColor.red
        return geo
    }

    func plot(_ plotView: PlotView, textAtTickMark index: Int, forAxis axis: PlotAxis) -> PlotText? {
        let config = PlotConfiguration()
        switch axis {
        case .x:
            return PlotText(text: "\(Int(CGFloat(index + 1) * config.xTickInterval))", fontSize: 0.3, offset: 0.25)
        case .y:
            return PlotText(text: "\(Int(CGFloat(index + 1) * config.yTickInterval))", fontSize: 0.3, offset: 0.1)
        case .z:
            return PlotText(text: "\(Int(CGFloat(index + 1) * config.zTickInterval))", fontSize: 0.3, offset: 0.25)
        }
    }
}
```

### Connecting Points
<img src="https://github.com/stokatyan/ReadMeMedia/blob/master/Plot3d/PlotView-2.gif"/>
Points can be connected to help with data visualization.  Connections can be made by implementing optional PlotDataSource and PlotDelegate functions.

```swift
// Optional PlotDataSource function for providing the number of connections to make.
func numberOfConnections() -> Int {
    return 15
}

// Optional PlotDelegate function for specifying which points to connect.
func plot(_ plotView: PlotView, pointsToConnectAt index: Int) -> (p0: Int, p1: Int)? {
    return (p0: index, p1: index + 1)
}

// Optional PlotDelegate function for specifying how each connection looks.
func plot(_ plotView: PlotView, connectionAt index: Int) -> PlotConnection? {
    return PlotConnection(radius: 0.025, color: .red)
}
```
