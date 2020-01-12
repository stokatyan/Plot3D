//
//  PlotDelegate.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/7/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import SceneKit

public protocol PlotDelegate: class {
    func plot(_ plotView: PlotView, pointForItemAt index: Int) -> PlotPoint
    func plot(_ plotView: PlotView, geometryForItemAt index: Int) -> SCNGeometry?
    func plot(_ plotView: PlotView, didSelectNode node: PlotPointNode, atIndex index: Int)
}

// MARK: - Default Implementations

public extension PlotDelegate {
    func plot(_ plotView: PlotView, didSelectNode node: PlotPointNode, atIndex index: Int) {}
}
