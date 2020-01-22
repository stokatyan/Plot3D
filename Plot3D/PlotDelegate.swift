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
     Delegates the task of setting the attributes for a connection.
     - parameters:
        - plotView: The `PlotView` that is used for showing the 3D plot.
        - index: The index of the connection.
     
      - returns:
      A `PlotConnection` which can be used to set the attributes of the connection's geometry.
     */
    func plot(_ plotView: PlotView, connectionAt index: Int) -> PlotConnection?
    
    /**
     The method that delegates the hnadling of a tapped node..
     - parameters:
        - plotView: The `PlotView` that is used for showing the 3D plot.
        - node: The `SCNNode` of the `Geometry` that has been selected.
        - index: The index of the item that was selected.
    */
    func plot(_ plotView: PlotView, didSelectNode node: PlotPointNode, atIndex index: Int)
    
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
     Delegates the task of determining which two points to connect for the given connection index.
     - parameters:
        - plotView: The `PlotView` that is used for showing the 3D plot.
        - index: The index of the connection.
     
      - returns:
      A pair of `Int`s correspoing to the indexes of the plotted points to connect.
     */
    func plot(_ plotView: PlotView, pointsToConnectAt index: Int) -> (p0: Int, p1: Int)?
    
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
     The method that delegates providing the points to plot.
     - parameters:
        - plotView: The `PlotView` that is used for showing the 3D plot.
        - index: The index of the item to plot.
     - returns:
     A `PlotPoint` for the coordinate to plot.
     */
    func plot(_ plotView: PlotView, textAtTickMark index: Int, forAxis axis: PlotAxis) -> PlotText?
    
}

// MARK: - Default Implementations

public extension PlotDelegate {
    func plot(_ plotView: PlotView, connectionAt index: Int) -> PlotConnection? {return nil}
    func plot(_ plotView: PlotView, didSelectNode node: PlotPointNode, atIndex index: Int) {}
    func plot(_ plotView: PlotView, pointsToConnectAt index: Int) -> (p0: Int, p1: Int)? {return nil}
    func plot(_ plotView: PlotView, textAtTickMark index: Int, forAxis axis: PlotAxis) -> PlotText? {return nil}
}
