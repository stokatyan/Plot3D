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
    
    /// The radius of the each axis line.
    let axisRadius: CGFloat
    /// The height of each axis line.
    let axisHeight: CGFloat
    /// The radius of each grid line.
    let gridlineRadius: CGFloat
    /// The bottom radius of the cone that is used to represent an arrow at the end of each axis line.
    let arrowBottomRadius: CGFloat
    /// The height of the cone that is used to represent an arrow at the end of each axis line.
    let arrowHeight: CGFloat
    
    /// The interval of graphed units between each gridline on the x-axis.
    let xTickInterval: CGFloat
    /// The interval of graphed units between each gridline on the y-axis.
    let yTickInterval: CGFloat
    /// The interval of graphed units between each gridline on the z-axis.
    let zTickInterval: CGFloat

    /// The max value along the x-axis.
    let xMax: CGFloat
    /// The max value along the y-axis.
    let yMax: CGFloat
    /// The max value along the z-axis.
    let zMax: CGFloat
    /// The min value along the x-axis.
    let xMin: CGFloat
    /// The min value along the y-axis.
    let yMin: CGFloat
    /// The min value along the z-axis.
    let zMin: CGFloat
    
    /// The color of the grid lines on the xy plane.
    let xyGridColor: UIColor
    /// The color of the grid lines on the xz plane.
    let xzGridColor: UIColor
    /// The color of the grid lines on the yz plane.
    let yzGridColor: UIColor
    
    /// The color of the unit sized plane adjacent to the origin on the xy plane.
    let xyUnitPlaneColor: UIColor
    /// The color of the unit sized plane adjacent to the origin on the xz plane.
    let xzUnitPlaneColor: UIColor
    /// The color of the unit sized plane adjacent to the origin on the yz plane.
    let yzUnitPlaneColor: UIColor
    
    /// The color of the xy plane.
    let xyPlaneColor: UIColor
    /// The color of the xz plane.
    let xzPlaneColor: UIColor
    /// The color of the yz plane.
    let yzPlaneColor: UIColor
    
    /// The thickness of each plane.
    let planeThickness: CGFloat
    
    static let defaultConfig = PlotConfiguration(axisRadius: 0.035,
                                                 axisHeight: 7,
                                                 gridlineRadius: 0.009,
                                                 arrowBottomRadius: 0.15,
                                                 arrowHeight: 0.3,
                                                 xTickInterval: 1,
                                                 yTickInterval: 2,
                                                 zTickInterval: 2.5,
                                                 xMax: 15,
                                                 yMax: 15,
                                                 zMax: 15,
                                                 xMin: 0,
                                                 yMin: 0,
                                                 zMin: 0,
                                                 xyGridColor: .red,
                                                 xzGridColor: .green,
                                                 yzGridColor: .yellow,
                                                 xyUnitPlaneColor: UIColor.red.withAlphaComponent(0.3),
                                                 xzUnitPlaneColor: UIColor.green.withAlphaComponent(0.3),
                                                 yzUnitPlaneColor: UIColor.yellow.withAlphaComponent(0.3),
                                                 xyPlaneColor: UIColor.red.withAlphaComponent(0.2),
                                                 xzPlaneColor: UIColor.green.withAlphaComponent(0.2),
                                                 yzPlaneColor: UIColor.yellow.withAlphaComponent(0.2),
                                                 planeThickness: 0.01)
}
