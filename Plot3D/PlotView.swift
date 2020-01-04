//
//  PlotView.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 12/15/19.
//  Copyright © 2019 Stokaty. All rights reserved.
//

import SceneKit

public class PlotView: UIView {
    
    // MARK: - Properties
    
    var sceneView: SCNView
    let scene: SCNScene
    
    // Nodes
    let plotNode: PlotNode
    let cameraNode: SCNNode
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        scene = SCNScene()
        cameraNode = SCNNode()
        plotNode = PlotNode(config: PlotConfiguration.defaultConfig)
        
        super.init(frame: frame)
        addSubview(sceneView)
        
        setupScene()
        setupCamera()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCamera() {
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        cameraNode.position = SCNVector3(x: 18, y: 18, z: 18)
        cameraNode.look(at: SCNVector3(x: 0, y: 0, z: 0))
    }
    
    func setupScene() {
        sceneView.backgroundColor = .black
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        
        scene.rootNode.addChildNode(plotNode)
    }
    
    // MARK: - Plotting
    
    public func plot(points: [PlotPoint]) {
        plotNode.plot(points: points.map({ point -> SCNVector3 in
            return point.vector
        }))
    }
    
    public func plot(points: [SCNVector3]) {
        plotNode.plot(points: points)
    }
    
    
    // MARK: - Update Configuration
    
    public func setUnitPlanes(isHidden: Bool) {
        plotNode.setUnitPlane(PlotPlane.xy, isHidden: isHidden)
        plotNode.setUnitPlane(PlotPlane.xz, isHidden: isHidden)
        plotNode.setUnitPlane(PlotPlane.yz, isHidden: isHidden)
    }
    
    public func setUnitPlan(_ plotPlane: PlotPlane, isHidden: Bool) {
        plotNode.setUnitPlane(plotPlane, isHidden: isHidden)
    }
    
}
