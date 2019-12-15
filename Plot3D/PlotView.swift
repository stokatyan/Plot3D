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
    let cameraNode: SCNNode
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        scene = SCNScene()
        cameraNode = SCNNode()
        super.init(frame: frame)
        addSubview(sceneView)
        
        setupScene()
        setupCamera()
        
        spawnShape()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCamera() {
      cameraNode.camera = SCNCamera()
      cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
      scene.rootNode.addChildNode(cameraNode)
    }
    
    func setupScene() {
        sceneView.backgroundColor = .black
        sceneView.scene = scene
    }
    
    func spawnShape() {
      let geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.3)
      let geometryNode = SCNNode(geometry: geometry)
      scene.rootNode.addChildNode(geometryNode)
    }
}
