//
//  PlotConfiguration.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/4/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import UIKit

public struct PlotConfiguration {
    
    let axisRadius: CGFloat
    let axisHeight: CGFloat
    let gridlineRadius: CGFloat
    let arrowBottomRadius: CGFloat
    let arrowHeight: CGFloat
    
    let xTickInterval: CGFloat
    let yTickInterval: CGFloat
    let zTickInterval: CGFloat
        
    let xMax: CGFloat
    let yMax: CGFloat
    let zMax: CGFloat
    let xMin: CGFloat
    let yMin: CGFloat
    let zMin: CGFloat
    
    let xyGridColor: UIColor
    let xzGridColor: UIColor
    let yzGridColor: UIColor
    
    static let defaultConfig = PlotConfiguration(axisRadius: 0.035,
                                                 axisHeight: 7,
                                                 gridlineRadius: 0.009,
                                                 arrowBottomRadius: 0.15,
                                                 arrowHeight: 0.3,
                                                 xTickInterval: 1,
                                                 yTickInterval: 2,
                                                 zTickInterval: 2.5,
                                                 xMax: 10,
                                                 yMax: 10,
                                                 zMax: 10,
                                                 xMin: 0,
                                                 yMin: 0,
                                                 zMin: 0,
                                                 xyGridColor: .red,
                                                 xzGridColor: .green,
                                                 yzGridColor: .yellow)
}
