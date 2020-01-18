//
//  PlotPoint.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/3/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import SceneKit

/**
 A point that can be plotted onto a `PlotView`.
 This object is used to avoid having to import `SceneKit` when creating the points to plot.
 */
public class PlotPoint {
    var x: CGFloat
    var y: CGFloat
    var z: CGFloat

    public init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    /// The `PlotPoint` represented as an`SCNVector3`.
    public var vector: SCNVector3 {
        return SCNVector3(x, y, z)
    }
}

