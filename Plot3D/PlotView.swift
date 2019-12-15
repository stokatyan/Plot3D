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
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func setupScene() {
        sceneView.backgroundColor = .black
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
    }
    
    func spawnShape() {
        let geometry = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.12)
        geometry.materials.first!.diffuse.contents = UIColor.red
        let geometryNode = SCNNode(geometry: geometry)
        
        let geometry2 = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.12)
        let geometryNode2 = SCNNode(geometry: geometry2)
        geometryNode2.position = SCNVector3(5, 5, 5)

        scene.rootNode.addChildNode(geometryNode)
        scene.rootNode.addChildNode(geometryNode2)
        
        cameraNode.position = SCNVector3(x: 7.5, y: 7.5, z: -2.5)
        cameraNode.look(at: SCNVector3(x: 2.5, y: 2.5, z: 2.5))
    }
}
