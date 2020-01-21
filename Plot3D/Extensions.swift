//
//  Extensions.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 12/18/19.
//  Copyright © 2019 Stokaty. All rights reserved.
//

import SceneKit

/**
 An extension to support the element-wise multiplication between two `SCNVector3`s.
 
 - returns: The element-wise product of two vectors.
 */
func * (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x * right.x, left.y * right.y, left.z * right.z)
}

func / (l: SCNVector3, r: Float) -> SCNVector3 {
    return SCNVector3Make(l.x/r, l.y/r, l.z/r)
}

func + (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(l.x + r.x, l.y + r.y, l.z + r.z)
}

func - (l: SCNVector3, r: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(l.x - r.x, l.y - r.y, l.z - r.z)
}


extension SCNVector3 {
    
    func distance(to otherVector: SCNVector3) -> Float {
        let diff = self - otherVector
        return diff.length()
    }
    
    func eulerAngles() -> SCNVector3 {
        let height = length()
        let lxz = sqrtf(x * x + z * z)
        let pitchB = y < 0 ? Float.pi - asinf(lxz/height) : asinf(lxz/height)
        let pitch = z == 0 ? pitchB : sign(z) * pitchB

        var yaw: Float = 0
        if x != 0 || z != 0 {
            let inner = x / (height * sinf(pitch))
            if inner > 1 || inner < -1 {
                yaw = Float.pi / 2
            } else {
                yaw = asinf(inner)
            }
        }
        return SCNVector3(CGFloat(pitch), CGFloat(yaw), 0)
    }
    
    func eulerAngles(to otherVector: SCNVector3) -> SCNVector3 {
        let diffVector = otherVector - self
        return diffVector.eulerAngles()
    }
    
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    func midPoint(to otherVector: SCNVector3) -> SCNVector3 {
        let diff = otherVector - self
        return diff/2 + self
    }
    
}
