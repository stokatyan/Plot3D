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
    
    public private(set) var sceneView: SCNView
    let scene: SCNScene
    
    private let plotNode: PlotNode
    public let cameraNode: SCNNode
    
    public var dataSource: PlotDataSource? {
        get {
            return plotNode.dataSource
        }
        set(newValue) {
            plotNode.dataSource = newValue
        }
    }
    
    public var delegate: PlotDelegate? {
        get {
            return plotNode.delegate
        }
        set(newValue) {
            plotNode.delegate = newValue
        }
    }
    
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
    
    public func refresh() {
        plotNode.refresh()
    }
    
    // MARK: - Getters
    
    public func getHorizontalGridLines(_ plotPlane: PlotPlane) -> [SCNNode] {
        switch plotPlane {
        case .xy:
            return plotNode.gridLinesHorizontalXY
        case .xz:
            return plotNode.gridLinesHorizontalXZ
        case .yz:
            return plotNode.gridLinesHorizontalYZ
        }
    }
    
    public func getVerticalGridLines(_ plotPlane: PlotPlane) -> [SCNNode] {
        switch plotPlane {
        case .xy:
            return plotNode.gridLinesVerticalXY
        case .xz:
            return plotNode.gridLinesVerticalXZ
        case .yz:
            return plotNode.gridLinesVerticalYZ
        }
    }
    
    // MARK: - Setters
    
    public func setCamera(position: PlotPoint) {
        cameraNode.position = position.vector
    }
    
    public func setCamera(lookAt position: PlotPoint) {
        cameraNode.look(at: position.vector)
    }
    
    public func setUnitPlanes(isHidden: Bool) {
        plotNode.setUnitPlane(PlotPlane.xy, isHidden: isHidden)
        plotNode.setUnitPlane(PlotPlane.xz, isHidden: isHidden)
        plotNode.setUnitPlane(PlotPlane.yz, isHidden: isHidden)
    }
    
    public func setUnitPlan(_ plotPlane: PlotPlane, isHidden: Bool) {
        plotNode.setUnitPlane(plotPlane, isHidden: isHidden)
    }
    
    public func setWalls(isHidden: Bool) {
        plotNode.setWall(PlotPlane.xy, isHidden: isHidden)
        plotNode.setWall(PlotPlane.xz, isHidden: isHidden)
        plotNode.setWall(PlotPlane.yz, isHidden: isHidden)
    }
    
    public func setWall(_ plotPlane: PlotPlane, isHidden: Bool) {
        plotNode.setWall(plotPlane, isHidden: isHidden)
    }
    
    public func setWall(_ plotPlane: PlotPlane, color: UIColor) {
        plotNode.setWall(plotPlane, color: color)
    }
    
}
