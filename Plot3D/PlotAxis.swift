//
//  PlotAxis.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/4/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import SceneKit

public enum PlotAxis {
    case x
    case y
    case z
    
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

public enum PlotPlane {
    case xy
    case xz
    case yz
}
