//
//  PlotAxis.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/4/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import SceneKit

/**
 The enumaration for each axis in the 3D plot space.
 */
public enum PlotAxis {
    case x
    case y
    case z
    
    /// An `SCNVector3` representing the direction of the axis in the 3D plot space.
    internal var direction: SCNVector3 {
        var d: SCNVector3
        switch self {
        case .x:
            d = SCNVector3(1, 0, 0)
        case .y:
            d = SCNVector3(0, 1, 0)
        case .z:
            d = SCNVector3(0, 0, 1)
        }
        return d
    }
    
    /// An `SCNVector3` representing the negative direction of the axis in the 3D plot space.
    internal var negativeDirection: SCNVector3 {
        var d: SCNVector3
        switch self {
        case .x:
            d = SCNVector3(-1, 0, 0)
        case .y:
            d = SCNVector3(0, -1, 0)
        case .z:
            d = SCNVector3(0, 0, -1)
        }
        return d
    }
}

/**
The enumaration for each plane in the 3D plot space.
*/
public enum PlotPlane {
    case xy
    case xz
    case yz
}
