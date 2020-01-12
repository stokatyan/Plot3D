//
//  PlotDelegate.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/7/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import SceneKit

public protocol PlotDelegate {
    func plot(_ plotSpace: PlotSpaceNode, pointForItemAt index: Int) -> PlotPoint
    func plot(_ plotSpace: PlotSpaceNode, geometryForItemAt index: Int) -> SCNGeometry?
    func plot(_ plotSpace: PlotSpaceNode, didSelectItemAt index: Int)
}

// MARK: - Default Implementations

public extension PlotDelegate {
    func plot(_ plotSpace: PlotSpaceNode, didSelectItemAt index: Int) {}
}
