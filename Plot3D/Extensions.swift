//
//  Extensions.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 12/18/19.
//  Copyright © 2019 Stokaty. All rights reserved.
//

import SceneKit

/**
 An extension to support element-wise multiplication between two `SCNVector3`s.
 
 - returns: The element-wise product of two vectors.
 */
func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}
