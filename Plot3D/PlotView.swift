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
    let axisNode: AxisNode
    let cameraNode: SCNNode
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        scene = SCNScene()
        cameraNode = SCNNode()
        axisNode = AxisNode(config: AxisConfiguration.defaultConfig)
        
        super.init(frame: frame)
        addSubview(sceneView)
        
        setupScene()
        setupCamera()
        
        addGrid()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCamera() {
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        cameraNode.position = SCNVector3(x: 11, y: 11, z: 11)
        cameraNode.look(at: SCNVector3(x: 0, y: 0, z: 0))
    }
    
    func setupScene() {
        sceneView.backgroundColor = .black
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        
        scene.rootNode.addChildNode(axisNode)
    }
    
    func addGrid() {
        
    }

}
