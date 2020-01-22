//
//  PlotView.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 12/15/19.
//  Copyright © 2019 Stokaty. All rights reserved.
//

import SceneKit

/**
 An object that manages the content of the `SCNView` that contains a plot in 3D.
 */
public class PlotView: UIView {
    
    // MARK: - Properties
    
    /// The `SCNView` that contains all of the nodes being plotted.
    public private(set) var sceneView: SCNView
    
    /// The scene that contains all of the plotted elements.
    let scene: SCNScene
    
    /// The node that contains everything being plotted.
    private let plotSpace: PlotSpaceNode
    /// The camera node in the scene.
    public let cameraNode: SCNNode
    
    /// The data source for the view's `plotSpaceNode`.
    public var dataSource: PlotDataSource? {
        get {
            return plotSpace.dataSource
        }
        set(newValue) {
            plotSpace.dataSource = newValue
        }
    }
    
    /// The delegate for the view's `plotSpaceNode`.
    public var delegate: PlotDelegate? {
        get {
            return plotSpace.delegate
        }
        set(newValue) {
            plotSpace.delegate = newValue
        }
    }
    
    /**
     If `true`, then nodes can be highlighted.  If `false`, then now there are no highlight lines.
     - note: This does not effect whether or not the plot delegates `didSelectNode` gets called.
     */
    public var highlightEnabled = true
    /// If `true`, then more than one plotted point can be highlighted when selected.  If `false`, then only the latest selection is highlighted.
    public var multipleHighlightsEnabled = false
    
    /// The radius of each highlight that connects a point to each plane.
    public var highlightRadius: CGFloat {
        get {
            return plotSpace.highlightRadius
        }
        set(newValue) {
            plotSpace.highlightRadius = newValue
        }
    }
    
    /// The color of each highlight that connects a point to each plane.
    public var highlightColor: UIColor {
        get {
            return plotSpace.highlightColor
        }
        set(newValue) {
            plotSpace.highlightColor = newValue
        }
    }
    
    // MARK: - Init
    
    /**
     Initializes a `PlotView` with the given frame.
     */
    public init(frame: CGRect, configuration: PlotConfiguration) {
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        scene = SCNScene()
        cameraNode = SCNNode()
        plotSpace = PlotSpaceNode(config: configuration)
        
        super.init(frame: frame)
        setupScene()
        setupCamera()
        
        addSubview(sceneView)
        scene.rootNode.addChildNode(plotSpace)
        plotSpace.plotView = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    /**
     Sets up the camera in the scene.
     The camera setup involves setting the possition of the camera, and what the camera is looking at.
     */
    func setupCamera() {
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        cameraNode.position = SCNVector3(x: 18, y: 18, z: 18)
        cameraNode.look(at: SCNVector3(x: 0, y: 0, z: 0))
    }
    
    /**
     Sets up the `sceneView`'s attributes.
     */
    func setupScene() {
        sceneView.backgroundColor = .black
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
    }
    
    // MARK: - Actions
    
    /**
     Handles tha tapping of a plotted node.
     
     When a tap gesture is recognized, the scene is checked to see if a plotted node has been tapped.
     If a plotted node is tapped, the action to be taken is delegated to the assigned `PlotDelegate`.
     */
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location: CGPoint = sender.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if let node = hits.first?.node as? PlotPointNode {
                if highlightEnabled {
                    if !multipleHighlightsEnabled {
                        plotSpace.removeHighlights()
                    }
                    plotSpace.highlightNode(node)
                }
                
                if let delegate = delegate {
                    delegate.plot(self, didSelectNode: node, atIndex: node.index)
                }
            }
        }
    }
    
    // MARK: - Plotting
    
    /**
    Plots any points that were added aftter the latest call to `refresh` or `plotNewPoints`.
    
    This function is intended for cases where most of the data has already been plotted, and only a couple of additional points need to be plotted.
    */
    public func plotNewPoints() {
        plotSpace.addNewPlotPoints()
        plotSpace.addNewConnections()
    }
    
    /**
    Safely returns the node plotted at the given index.
    - parameter index: the index of that plotted node.
    - returns: an optional reference to the `SCNNode` that is plotted at the given index.
    */
    public func plottedPoint(atIndex index: Int) -> SCNNode? {
        return plotSpace.plottedPoint(atIndex: index)
    }
    
    /**
    Reloads the plotted points using the plot data source and plot delegate.
    This function is analagous to a `UITableView`'s `reloadData()` function.
    */
    public func reloadData() {
        plotSpace.reloadData()
    }
    
    /**
     Removes all highlights from the plot space.
     */
    public func removeHighlights() {
        plotSpace.removeHighlights()
    }
        
    // MARK: - Getters
    
    /**
     - returns: An array containing all of the horizontal gridlines on the given plane.
     */
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
    
    /**
     - returns: An array containing all of the vertical gridlines on the given plane.
     */
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
    
    /**
     Sets a title for the given axis.
     - parameters:
        - axis: The axis to set a title for.
        - text: The text to use for the created node's geometry.
        - textColor: The color to use for the created node's geometry.
        - fontName: The name of the font for the text.
        - fontSize: The size of the font for the text.
        - flatness: A number that determines the accuracy or smoothness of the text geometry, the closer to 0 the smoother the geometry.
        - offset: The offset between the top of the title and the axis height.
    */
    public func setAxisTitle(_ axis: PlotAxis,
                             text: String,
                             textColor: UIColor = .lightText,
                             fontName: String = "AppleSDGothicNeo-UltraLight",
                             fontSize: CGFloat = 0.5,
                             flatness: CGFloat = 0.001,
                             offset: CGFloat = 0.6) {
        let plotText = PlotText(text: text, textColor: textColor, fontName: fontName, fontSize: fontSize, flatness: flatness, offset: offset)
        plotSpace.setAxisTitle(axis, plotText: plotText)
    }
    
    /**
     Sets the camera position using a `PlotPoint` instead of an SCNVector.
     */
    public func setCamera(position: PlotPoint) {
        cameraNode.position = position.vector
    }
    
    /**
    Sets the camera orientation using a `PlotPoint` instead of an SCNVector.
    */
    public func setCamera(lookAt position: PlotPoint) {
        cameraNode.look(at: position.vector)
    }
    
    /**
     Sets the `isHidden` property of all of the unit planes.
     - parameter isHidden: Whether or not all of the unit planes should be hidden.
     */
    public func setUnitPlanes(isHidden: Bool) {
        plotSpace.setUnitPlane(PlotPlane.xy, isHidden: isHidden)
        plotSpace.setUnitPlane(PlotPlane.xz, isHidden: isHidden)
        plotSpace.setUnitPlane(PlotPlane.yz, isHidden: isHidden)
    }
    
    /**
    Sets the `isHidden` property of the unit plane for the given plane.
    - parameters:
        - plotPlane: The plot plane that will be effected.
        - isHidden: Whether or not the unit plane for the given plane should be hidden.
    */
    public func setUnitPlan(_ plotPlane: PlotPlane, isHidden: Bool) {
        plotSpace.setUnitPlane(plotPlane, isHidden: isHidden)
    }
    
    /**
    Sets the `isHidden` property of the walls for each plane.
    - parameter isHidden: Whether or not all of the walls should be hidden.
    */
    public func setWalls(isHidden: Bool) {
        plotSpace.setWall(PlotPlane.xy, isHidden: isHidden)
        plotSpace.setWall(PlotPlane.xz, isHidden: isHidden)
        plotSpace.setWall(PlotPlane.yz, isHidden: isHidden)
    }
    
    /**
    Sets the `isHidden` property of the wall for the given plane.
    - parameters:
        - plotPlane: The plot plane that will be effected.
        - isHidden: Whether or not wall for the given plane should be hidden.
    */
    public func setWall(_ plotPlane: PlotPlane, isHidden: Bool) {
        plotSpace.setWall(plotPlane, isHidden: isHidden)
    }
    
    /**
    Sets the `color` property of the wall for the given plane.
    - parameters:
        - plotPlane: The plot plane that will be effected.
        - color: The color for the wall on the given plane.
    */
    public func setWall(_ plotPlane: PlotPlane, color: UIColor) {
        plotSpace.setWall(plotPlane, color: color)
    }
    
}
