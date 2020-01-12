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
    
    private let plotSpace: PlotSpaceNode
    public let cameraNode: SCNNode
    
    public var dataSource: PlotDataSource? {
        get {
            return plotSpace.dataSource
        }
        set(newValue) {
            plotSpace.dataSource = newValue
        }
    }
    
    public var delegate: PlotDelegate? {
        get {
            return plotSpace.delegate
        }
        set(newValue) {
            plotSpace.delegate = newValue
        }
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        scene = SCNScene()
        cameraNode = SCNNode()
        plotSpace = PlotSpaceNode(config: PlotConfiguration.defaultConfig)
        
        super.init(frame: frame)
        addSubview(sceneView)
        
        setupScene()
        setupCamera()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        //Add recognizer to sceneview
//        sceneView.addGestureRecognizer(tapGesture)
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
        
        scene.rootNode.addChildNode(plotSpace)
    }
    
    // MARK: - Actions
    
    func handleTap(sender: UITapGestureRecognizer) {
        guard let delegate = delegate else {
            return
        }
        
        if sender.state == .ended {
            let location: CGPoint = sender.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if let tappedNode = hits.first?.node {
//                delegate.plot(plotSpace, didSelectItemAt: tappedNode.)
            }
        }
    }
    
    // MARK: - Plotting
    
    public func plotNewPoints() {
        plotSpace.plotNewPoints()
    }
    
    public func plottedPoint(atIndex index: Int) -> SCNNode? {
        return plotSpace.plottedPoint(atIndex: index)
    }
    
    public func refresh() {
        plotSpace.refresh()
    }
        
    // MARK: - Getters
    
    public func getHorizontalGridLines(_ plotPlane: PlotPlane) -> [SCNNode] {
        switch plotPlane {
        case .xy:
            return plotSpace.gridLinesHorizontalXY
        case .xz:
            return plotSpace.gridLinesHorizontalXZ
        case .yz:
            return plotSpace.gridLinesHorizontalYZ
        }
    }
    
    public func getVerticalGridLines(_ plotPlane: PlotPlane) -> [SCNNode] {
        switch plotPlane {
        case .xy:
            return plotSpace.gridLinesVerticalXY
        case .xz:
            return plotSpace.gridLinesVerticalXZ
        case .yz:
            return plotSpace.gridLinesVerticalYZ
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
        plotSpace.setUnitPlane(PlotPlane.xy, isHidden: isHidden)
        plotSpace.setUnitPlane(PlotPlane.xz, isHidden: isHidden)
        plotSpace.setUnitPlane(PlotPlane.yz, isHidden: isHidden)
    }
    
    public func setUnitPlan(_ plotPlane: PlotPlane, isHidden: Bool) {
        plotSpace.setUnitPlane(plotPlane, isHidden: isHidden)
    }
    
    public func setWalls(isHidden: Bool) {
        plotSpace.setWall(PlotPlane.xy, isHidden: isHidden)
        plotSpace.setWall(PlotPlane.xz, isHidden: isHidden)
        plotSpace.setWall(PlotPlane.yz, isHidden: isHidden)
    }
    
    public func setWall(_ plotPlane: PlotPlane, isHidden: Bool) {
        plotSpace.setWall(plotPlane, isHidden: isHidden)
    }
    
    public func setWall(_ plotPlane: PlotPlane, color: UIColor) {
        plotSpace.setWall(plotPlane, color: color)
    }
    
}
