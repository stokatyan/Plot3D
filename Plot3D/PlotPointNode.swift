//
//  PlotPointNode.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/12/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import SceneKit

public class PlotPointNode: SCNNode {
    
    var index: Int
    
    init(geometry: SCNGeometry?, index: Int) {
        self.index = index
        super.init()
        self.geometry = geometry
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
