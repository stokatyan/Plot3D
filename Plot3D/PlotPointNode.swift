//
//  PlotPointNode.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/12/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import SceneKit

/**
 A subclass of `SCNNode` that has an `index` property used so that each node on the 3D plot knows the index of the data point that it corresponds to.
 */
public class PlotPointNode: SCNNode {
    
    /// The index of the data point that the node corresponds to.
    var index: Int
    
    /**
     Initializes a `PlotPointNode` with the given geometry corresponding to a data point at the given index.
     - parameters:
        - geometry: The optional `SCNGeometry` to place at the node.
        - index: The index of the data point that the node corresponds to.
     */
    init(geometry: SCNGeometry?, index: Int) {
        self.index = index
        super.init()
        self.geometry = geometry
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
