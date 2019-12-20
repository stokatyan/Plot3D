//
//  Extensions.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 12/18/19.
//  Copyright © 2019 Stokaty. All rights reserved.
//

import SceneKit

extension SCNGeometry {
    static func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]

        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        return SCNGeometry(sources: [source], elements: [element])
    }
}
