//
//  PlotConfiguration.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/4/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import UIKit

/**
 The properties required for configuring a 3D plot space.
 */
public struct PlotConfiguration {
    
    /// The height of the cylinder for the x axis.
    public var xAxisHeight: CGFloat
    /// The height of the cylinder for the y axis.
    public var yAxisHeight: CGFloat
    /// The height of the cylinder for the z axis.
    public var zAxisHeight: CGFloat
    /// The radius of the each axis line.
    public var axisRadius: CGFloat
    /// The radius of each grid line.
    public var gridlineRadius: CGFloat
    /// The bottom radius of the cone that is used to represent an arrow at the end of each axis line.
    public var arrowBottomRadius: CGFloat
    /// The height of the cone that is used to represent an arrow at the end of each axis line.
    public var arrowHeight: CGFloat
    
    /// The interval of graphed units between each gridline on the x-axis.
    public var xTickInterval: CGFloat
    /// The interval of graphed units between each gridline on the y-axis.
    public var yTickInterval: CGFloat
    /// The interval of graphed units between each gridline on the z-axis.
    public var zTickInterval: CGFloat

    /// The max value along the x-axis.
    public var xMax: CGFloat
    /// The max value along the y-axis.
    public var yMax: CGFloat
    /// The max value along the z-axis.
    public var zMax: CGFloat
    /// The min value along the x-axis.
    public var xMin: CGFloat
    /// The min value along the y-axis.
    public var yMin: CGFloat
    /// The min value along the z-axis.
    public var zMin: CGFloat
    
    /// The color of the grid lines on the xy plane.
    public var xyGridColor: UIColor
    /// The color of the grid lines on the xz plane.
    public var xzGridColor: UIColor
    /// The color of the grid lines on the yz plane.
    public var yzGridColor: UIColor
    
    /// The color of the unit sized plane adjacent to the origin on the xy plane.
    public var xyUnitPlaneColor: UIColor
    /// The color of the unit sized plane adjacent to the origin on the xz plane.
    public var xzUnitPlaneColor: UIColor
    /// The color of the unit sized plane adjacent to the origin on the yz plane.
    public var yzUnitPlaneColor: UIColor
    
    /// The color of the xy plane.
    public var xyPlaneColor: UIColor
    /// The color of the xz plane.
    public var xzPlaneColor: UIColor
    /// The color of the yz plane.
    public var yzPlaneColor: UIColor
    
    /// The thickness of each plane.
    public var planeThickness: CGFloat
    
    public init(xAxisHeight: CGFloat = 7,
                yAxisHeight: CGFloat = 7,
                zAxisHeight: CGFloat = 7,
                axisRadius: CGFloat = 0.035,
                gridlineRadius: CGFloat = 0.009,
                arrowBottomRadius: CGFloat = 0.15,
                arrowHeight: CGFloat = 0.3,
                xTickInterval: CGFloat = 3,
                yTickInterval: CGFloat = 5,
                zTickInterval: CGFloat = 3,
                xMax: CGFloat = 15,
                yMax: CGFloat = 15,
                zMax: CGFloat = 15,
                xMin: CGFloat = 0,
                yMin: CGFloat = 0,
                zMin: CGFloat = 0,
                xyGridColor: UIColor = .white,
                xzGridColor: UIColor = .white,
                yzGridColor: UIColor = .white,
                xyUnitPlaneColor: UIColor = UIColor.white.withAlphaComponent(0.3),
                xzUnitPlaneColor: UIColor = UIColor.white.withAlphaComponent(0.3),
                yzUnitPlaneColor: UIColor = UIColor.white.withAlphaComponent(0.3),
                xyPlaneColor: UIColor = UIColor.lightGray.withAlphaComponent(0.6),
                xzPlaneColor: UIColor = UIColor.lightGray.withAlphaComponent(0.6),
                yzPlaneColor: UIColor = UIColor.lightGray.withAlphaComponent(0.6),
                planeThickness: CGFloat = 0.01) {
        
        self.axisRadius = axisRadius
        self.xAxisHeight = xAxisHeight
        self.yAxisHeight = yAxisHeight
        self.zAxisHeight = zAxisHeight
        self.gridlineRadius = gridlineRadius
        self.arrowBottomRadius = arrowBottomRadius
        self.arrowHeight = arrowHeight
        self.xTickInterval = xTickInterval
        self.yTickInterval = yTickInterval
        self.zTickInterval = zTickInterval
        self.xMax = xMax
        self.yMax = yMax
        self.zMax = zMax
        self.xMin = xMin
        self.yMin = yMin
        self.zMin = zMin
        self.xyGridColor = xyGridColor
        self.xzGridColor = xzGridColor
        self.yzGridColor = yzGridColor
        self.xyUnitPlaneColor = xyUnitPlaneColor
        self.xzUnitPlaneColor = xzUnitPlaneColor
        self.yzUnitPlaneColor = yzUnitPlaneColor
        self.xyPlaneColor = xyPlaneColor
        self.xzPlaneColor = xzPlaneColor
        self.yzPlaneColor = yzPlaneColor
        self.planeThickness = planeThickness
    
    }
    
}
