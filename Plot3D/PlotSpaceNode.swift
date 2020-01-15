//
//  PlotSpaceNode.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 12/19/19.
//  Copyright © 2019 Stokaty. All rights reserved.
//

import SceneKit

/**
 The node that is the parent for all of the points being plotted and visual planes, graphs, and axis.
 */
public class PlotSpaceNode: SCNNode {
    
    // MARK: - Properties
    
    // Axis
    /// The height of the cylinder for each axis.
    let axisHeight: CGFloat
    /// The radius of the cylinder for each axis.
    let axisRadius: CGFloat
    /// The radius of the cyclinder for each gridline.
    let gridlineRadius: CGFloat
    /// The geometry of the x axis.
    let xAxis: SCNGeometry
    /// The geometry of the y axis.
    let yAxis: SCNGeometry
    /// The geometry of the z axis.
    let zAxis: SCNGeometry
    /// The node for the x axis.
    let xAxisNode: SCNNode
    /// The node for the y axis.
    let yAxisNode: SCNNode
    /// The node for the z axis.
    let zAxisNode: SCNNode
    /// The geometry of the origin node.
    let originGeometry: SCNGeometry
    
    // Axis Arrows
    /// The geometry of the arrow on the x axis.
    let xAxisArrow: SCNGeometry
    /// The geometry of the arrow on the y axis.
    let yAxisArrow: SCNGeometry
    /// The geometry of the arrow on the z axis.
    let zAxisArrow: SCNGeometry
    /// The node for the arrow on the x axis.
    let xArrowNode: SCNNode
    /// The node for the arrow on the y axis.
    let yArrowNode: SCNNode
    /// The node for the arrow on the z axis.
    let zArrowNode: SCNNode
    
    // Planes
    /// The plane that is one unit in size to show the xy plane.
    let unitPlaneXY: SCNGeometry
    /// The plane that is one unit in size to show the xz plane.
    let unitPlaneXZ: SCNGeometry
    /// The plane that is one unit in size to show the yz plane.
    let unitPlaneYZ: SCNGeometry
    /// The node for the xy unit plane.
    let unitPlaneXYNode: SCNNode
    /// The node for the xz unit plane.
    let unitPlaneXZNode: SCNNode
    /// The node for the yz unit plane.
    let unitPlaneYZNode: SCNNode
    
    /// The geometry for the wall on the xy plane.
    let wallXY: SCNGeometry
    /// The geometry for the wall on the xz plane.
    let wallXZ: SCNGeometry
    /// The geometry for the wall on the yz plane.
    let wallYZ: SCNGeometry
    /// The geometry for the wall on the xy plane.
    let wallXYNode: SCNNode
    /// The geometry for the wall on the xz plane.
    let wallXZNode: SCNNode
    /// The geometry for the wall on the yz plane.
    let wallYZNode: SCNNode
    
    /// The horizontal gridlines on the XY plane.
    public private(set) var gridLinesHorizontalXY = [SCNNode]()
    /// The horizontal gridlines on the XZ plane.
    public private(set) var gridLinesHorizontalXZ = [SCNNode]()
    /// The horizontal gridlines on the YZ plane.
    public private(set) var gridLinesHorizontalYZ = [SCNNode]()
    /// The vertical gridlines on the XY plane.
    public private(set) var gridLinesVerticalXY = [SCNNode]()
    /// The vertical gridlines on the XZ plane.
    public private(set) var gridLinesVerticalXZ = [SCNNode]()
    /// The vertical gridlines on the YZ plane.
    public private(set) var gridLinesVerticalYZ = [SCNNode]()
    
    /// The max value on the x axis (the value at the arrow).
    private var xMax: CGFloat
    /// The max value on the y axis (the value at the arrow).
    private var yMax: CGFloat
    /// The max value on the z axis (the value at the arrow).
    private var zMax: CGFloat
    /// The min value on the x axis (the value at the origin).
    private var xMin: CGFloat
    /// The min value on the y axis (the value at the origin).
    private var yMin: CGFloat
    /// The min value on the z axis (the value at the origin).
    private var zMin: CGFloat
    
    // Plotting
    /// The root node of all of the plotted points.
    private var plotPointRootNode: SCNNode
    /// The plotted points.
    private var plottedPoints = [SCNNode]()
    
    weak var dataSource: PlotDataSource?
    weak var delegate: PlotDelegate?
    /// The `PlotView` that has the scene that this `PlotSpaceNode` is in.
    weak var plotView: PlotView?
    
    // MARK: - Init
    
    /**
     Initialize a `PlotSpaceNode` with the given configuration.
     - parameter config: The configuration that defines the attributes to use.
     */
    init(config: PlotConfiguration) {
        
        axisHeight = config.axisHeight
        axisRadius = config.axisRadius
        gridlineRadius = config.gridlineRadius
        xAxis = SCNCylinder(radius: axisRadius, height: axisHeight)
        yAxis = SCNCylinder(radius: axisRadius, height: axisHeight)
        zAxis = SCNCylinder(radius: axisRadius, height: axisHeight)
        
        xAxisArrow = SCNCone(topRadius: 0, bottomRadius: config.arrowBottomRadius, height: config.arrowHeight)
        yAxisArrow = SCNCone(topRadius: 0, bottomRadius: config.arrowBottomRadius, height: config.arrowHeight)
        zAxisArrow = SCNCone(topRadius: 0, bottomRadius: config.arrowBottomRadius, height: config.arrowHeight)
        
        xAxisNode = SCNNode(geometry: xAxis)
        yAxisNode = SCNNode(geometry: yAxis)
        zAxisNode = SCNNode(geometry: zAxis)
        
        xArrowNode = SCNNode(geometry: xAxisArrow)
        yArrowNode = SCNNode(geometry: yAxisArrow)
        zArrowNode = SCNNode(geometry: zAxisArrow)
        
        originGeometry = SCNSphere(radius: axisRadius)
                
        let xGridSpacing = PlotSpaceNode.coordinate(forValue: config.xTickInterval,
                                               axisMaxValue: config.xMax,
                                               axisMinValue: config.xMin,
                                               axisHeight: config.axisHeight)
        let yGridSpacing = PlotSpaceNode.coordinate(forValue: config.yTickInterval,
                                               axisMaxValue: config.yMax,
                                               axisMinValue: config.yMin,
                                               axisHeight: config.axisHeight)
        let zGridSpacing = PlotSpaceNode.coordinate(forValue: config.zTickInterval,
                                               axisMaxValue: config.zMax,
                                               axisMinValue: config.zMin,
                                               axisHeight: config.axisHeight)
        
        unitPlaneXY = SCNPlane(width: xGridSpacing, height: yGridSpacing)
        unitPlaneXZ = SCNPlane(width: xGridSpacing, height: zGridSpacing)
        unitPlaneYZ = SCNPlane(width: zGridSpacing, height: yGridSpacing)
        unitPlaneXYNode = SCNNode(geometry: unitPlaneXY)
        unitPlaneXZNode = SCNNode(geometry: unitPlaneXZ)
        unitPlaneYZNode = SCNNode(geometry: unitPlaneYZ)
        
        wallXY = SCNBox(width: axisHeight, height: axisHeight, length: config.planeThickness, chamferRadius: 0)
        wallXZ = SCNBox(width: axisHeight, height: axisHeight, length: config.planeThickness, chamferRadius: 0)
        wallYZ = SCNBox(width: axisHeight, height: axisHeight, length: config.planeThickness, chamferRadius: 0)
        wallXYNode = SCNNode(geometry: wallXY)
        wallXZNode = SCNNode(geometry: wallXZ)
        wallYZNode = SCNNode(geometry: wallYZ)
        
        plotPointRootNode = SCNNode()
        
        xMax = config.xMax
        yMax = config.yMax
        zMax = config.zMax
        xMin = config.xMin
        yMin = config.yMin
        zMin = config.zMin
        
        super.init()
        
        setupAxis(axisHeight: axisHeight)
        setupUnitPlanes(xGridSpacing: xGridSpacing, yGridSpacing: yGridSpacing, zGridSpacing: zGridSpacing, config: config)
        
        // xy grid lines
        gridLinesHorizontalXY += addGridLines(rootNode: xAxisNode, spacing: yGridSpacing, direction: PlotAxis.x.negativeDirection, color: config.xyGridColor)
        gridLinesVerticalXY += addGridLines(rootNode: yAxisNode, spacing: xGridSpacing, direction: PlotAxis.x.direction, color: config.xyGridColor)
        // xz grid lines
        gridLinesHorizontalXZ += addGridLines(rootNode: xAxisNode, spacing: zGridSpacing, direction: PlotAxis.z.direction, color: config.xzGridColor)
        gridLinesVerticalXZ += addGridLines(rootNode: zAxisNode, spacing: xGridSpacing, direction: PlotAxis.x.direction, color: config.xzGridColor)
        // yz grid lines
        gridLinesVerticalYZ += addGridLines(rootNode: yAxisNode, spacing: zGridSpacing, direction: PlotAxis.z.direction, color: config.yzGridColor)
        gridLinesHorizontalYZ += addGridLines(rootNode: zAxisNode, spacing: yGridSpacing, direction: PlotAxis.z.negativeDirection, color: config.yzGridColor)
        
        addWall(plane: .xy, color: config.xyPlaneColor)
        addWall(plane: .xz, color: config.xzPlaneColor)
        addWall(plane: .yz, color: config.yzPlaneColor)
        
        addChildNode(plotPointRootNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    /**
     Sets up each axis and adds them as a child node.
     - parameter axisHeight: The height of each axis.
     */
    private func setupAxis(axisHeight: CGFloat) {
        xAxisNode.position = SCNVector3(axisHeight/2, 0, 0)
        xAxisNode.eulerAngles = SCNVector3(0, 0, -Double.pi/2)
        xArrowNode.position = SCNVector3(0, axisHeight/2, 0)
        xAxisNode.addChildNode(xArrowNode)
        addChildNode(xAxisNode)

        yAxisNode.position = SCNVector3(0, axisHeight/2, 0)
        yArrowNode.position = SCNVector3(0, axisHeight/2, 0)
        yAxisNode.addChildNode(yArrowNode)
        addChildNode(yAxisNode)
        
        zAxisNode.position = SCNVector3(0, 0, axisHeight/2)
        zAxisNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
        zArrowNode.position = SCNVector3(0, axisHeight/2, 0)
        zAxisNode.addChildNode(zArrowNode)
        addChildNode(zAxisNode)

        originGeometry.materials.first!.diffuse.contents = UIColor.white
        let originNode = SCNNode(geometry: originGeometry)
        originNode.position = SCNVector3(0, 0, 0)
        addChildNode(originNode)
    }
    
    /**
     Sets up the unit planes for each axis and adds them as child nodes.
     - parameters:
        - xGridSpacing: The spacing between gridlines on the x axis.
        - yGridSpacing: The spacing between gridlines on the y axis.
        - zGridSpacing: The spacing between gridlines on the z axis.
        - config: The configuration which contains the colors to use for each grid.
     */
    private func setupUnitPlanes(xGridSpacing: CGFloat, yGridSpacing: CGFloat, zGridSpacing: CGFloat, config: PlotConfiguration) {
        let xOffset = xGridSpacing/2
        let yOffset = yGridSpacing/2
        let zOffset = zGridSpacing/2
        
        unitPlaneXY.materials.first!.diffuse.contents = config.xyGridColor
        unitPlaneXYNode.position = SCNVector3(xOffset, yOffset, 0)
        addChildNode(unitPlaneXYNode)
        
        unitPlaneXZ.materials.first!.diffuse.contents = config.xzGridColor
        unitPlaneXZNode.eulerAngles = SCNVector3(-Double.pi/2, 0, 0)
        unitPlaneXZNode.position = SCNVector3(xOffset, 0, zOffset)
        addChildNode(unitPlaneXZNode)
        
        unitPlaneYZ.materials.first!.diffuse.contents = config.yzGridColor
        unitPlaneYZNode.eulerAngles = SCNVector3(0, Double.pi/2, 0)
        unitPlaneYZNode.position = SCNVector3(0, yOffset, zOffset)
        addChildNode(unitPlaneYZNode)
    }
    
    /**
    Adds gridlines to the given node in the given direction.  The gridlines are added as children to the root node.
    - parameters:
       - rootNode: The node that the gridlines will be added to.
       - spacing: The spacing between gridlines.
       - direction: The direction to place the gridlines.
       - color: The color for the gridlines.
     - returns: The array of nodes that contains the gridlines that were added.
    */
    private func addGridLines(rootNode: SCNNode, spacing: CGFloat, direction: SCNVector3, color: UIColor) -> [SCNNode] {
        let lineCount = Int(axisHeight/spacing)
        var gridLines = [SCNNode]()
        for i in 0..<lineCount {
            let gridLine = SCNCylinder(radius: gridlineRadius, height: axisHeight)
            gridLine.materials.first!.diffuse.contents = color
            let gridLineNode = SCNNode(geometry: gridLine)
            let position = spacing * CGFloat(i + 1)
            gridLineNode.position = SCNVector3(position, position, position) * direction
            rootNode.addChildNode(gridLineNode)
            gridLines.append(gridLineNode)
        }
        
        return gridLines
    }
    
    /**
     Adds the wall for the given plane.
     - parameters:
        - plane: The plane for the wall to be added on.
        - color: The color of the wall go add.
     */
    private func addWall(plane: PlotPlane, color: UIColor) {
        setWall(plane, color: color)
        
        let offset = axisHeight/2
        var wallNode: SCNNode
        switch plane {
        case .xy:
            wallNode = wallXYNode
            wallNode.position = SCNVector3(offset, offset, 0)
        case .xz:
            wallNode = wallXZNode
            wallNode.eulerAngles = SCNVector3(-Double.pi/2, 0, 0)
            wallNode.position = SCNVector3(offset, 0, offset)
        case .yz:
            wallNode = wallYZNode
            wallNode.eulerAngles = SCNVector3(0, Double.pi/2, 0)
            wallNode.position = SCNVector3(0, offset, offset)
        }
        
        addChildNode(wallNode)
    }
    
    // MARK: - Plotting
    
    private static func coordinate(forValue value: CGFloat, axisMaxValue: CGFloat, axisMinValue: CGFloat, axisHeight: CGFloat) -> CGFloat {
        return value * (axisHeight/(axisMaxValue - axisMinValue))
    }
    
    private func coordinate(forValue value: CGFloat, axisMaxValue: CGFloat, axisMinValue: CGFloat) -> CGFloat {
        return PlotSpaceNode.coordinate(forValue: value, axisMaxValue: axisMaxValue, axisMinValue: axisMinValue, axisHeight: self.axisHeight)
    }
    
    private func plot(_ point: PlotPoint, geometry: SCNGeometry?) {
        let pointNode = PlotPointNode(geometry: geometry, index: plottedPoints.count)
        let x = coordinate(forValue: point.x, axisMaxValue: xMax, axisMinValue: xMin)
        let y = coordinate(forValue: point.y, axisMaxValue: yMax, axisMinValue: yMin)
        let z = coordinate(forValue: point.z, axisMaxValue: zMax, axisMinValue: zMin)
        pointNode.position = SCNVector3(x, y, z)
        
        plottedPoints.append(pointNode)
        plotPointRootNode.addChildNode(pointNode)
    }
    
    func plottedPoint(atIndex index: Int) -> SCNNode? {
        guard index < plottedPoints.count else {
            return nil
        }
        
        return plottedPoints[index]
    }
    
    // MARK: - Update Plot
    
    func plotNewPoints() {
        guard let dataSource = dataSource, let delegate = delegate, let plotView = plotView else {
            return
        }
        
        let currentPointCount = plottedPoints.count
        let additionalPointCount = dataSource.numberOfPoints() - currentPointCount
        
        guard additionalPointCount > 0 else {
            return
        }
        
        let startIndex = currentPointCount
        for index in 0..<additionalPointCount {
            let plotPoint = delegate.plot(plotView, pointForItemAt: index + startIndex)
            let geometry = delegate.plot(plotView, geometryForItemAt: index + startIndex)
            plot(plotPoint, geometry: geometry)
        }
    }
    
    func refresh() {
        removeAllPlottedPoints()
        
        guard let dataSource = dataSource, let delegate = delegate, let plotView = plotView else {
            return
        }
        
        let numberOfPoints = dataSource.numberOfPoints()
        guard numberOfPoints > 0 else {
            return
        }
        
        for index in 0..<numberOfPoints {
            let plotPoint = delegate.plot(plotView, pointForItemAt: index)
            let geometry = delegate.plot(plotView, geometryForItemAt: index)
            plot(plotPoint, geometry: geometry)
        }
    }
    
    private func removeAllPlottedPoints() {
        plottedPoints.removeAll()
        plotPointRootNode.removeFromParentNode()
        plotPointRootNode = SCNNode()
        addChildNode(plotPointRootNode)
    }
    
    // MARK: Update Configuration
    
    func setUnitPlane(_ plane: PlotPlane, isHidden: Bool) {
        switch plane {
        case PlotPlane.xy:
            unitPlaneXYNode.isHidden = isHidden
        case PlotPlane.xz:
            unitPlaneXZNode.isHidden = isHidden
        case PlotPlane.yz:
            unitPlaneYZNode.isHidden = isHidden
        }
    }
    
    func setWall(_ plane: PlotPlane, isHidden: Bool) {
        switch plane {
        case PlotPlane.xy:
            wallXYNode.isHidden = isHidden
        case PlotPlane.xz:
            wallXZNode.isHidden = isHidden
        case PlotPlane.yz:
            wallYZNode.isHidden = isHidden
        }
    }
    
    func setWall(_ plane: PlotPlane, color: UIColor) {
        switch plane {
        case PlotPlane.xy:
            wallXY.materials.first!.diffuse.contents = color
        case PlotPlane.xz:
            wallXZ.materials.first!.diffuse.contents = color
        case PlotPlane.yz:
            wallYZ.materials.first!.diffuse.contents = color
        }
    }
    
}
