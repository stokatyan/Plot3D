//
//  PlotDelegate.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/7/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import SceneKit

/**
 A protocol containing the methods for providing the 3D plot with coordinates, geometries and handling selection.
 */
public protocol PlotDelegate: class {
    
    /**
     The method that delegates providing the points to plot.
     - parameters:
        - plotView: The `PlotView` that is used for showing the 3D plot.
        - index: The index of the item to plot.
     - returns:
     A `PlotPoint` for the coordinate to plot.
     */
    func plot(_ plotView: PlotView, pointForItemAt index: Int) -> PlotPoint
    
    /**
    The method that delegates providing the geometries to plot.
    - parameters:
       - plotView: The `PlotView` that is used for showing the 3D plot.
       - index: The index of the item to plot.
    - returns:
    An optional `SCNGeometry` for the item being plotted at the given index.  If this is `nil`, then no visible geometry is plotted.
    */
    func plot(_ plotView: PlotView, geometryForItemAt index: Int) -> SCNGeometry?
    
    /**
    The method that delegates the hnadling of a tapped node..
    - parameters:
       - plotView: The `PlotView` that is used for showing the 3D plot.
       - node: The `SCNNode` of the `Geometry` that has been selected.
       - index: The index of the item that was selected.
    */
    func plot(_ plotView: PlotView, didSelectNode node: PlotPointNode, atIndex index: Int)
}

// MARK: - Default Implementations

public extension PlotDelegate {
    func plot(_ plotView: PlotView, didSelectNode node: PlotPointNode, atIndex index: Int) {}
}
