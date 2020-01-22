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
    /// The height of the cylinder for the x axis.
    let xAxisHeight: CGFloat
    /// The height of the cylinder for the y axis.
    let yAxisHeight: CGFloat
    /// The height of the cylinder for the z axis.
    let zAxisHeight: CGFloat
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
    
    /// The root node for the x axis tick marks.
    var xTickMarksNode = SCNNode()
    /// The root node for the y axis tick marks.
    var yTickMarksNode = SCNNode()
    /// The root node for the z axis tick marks.
    var zTickMarksNode = SCNNode()
    
    /// The node for the x axis title.
    var xAxisTitleNode = SCNNode()
    /// The node for the y axis title.
    var yAxisTitleNode = SCNNode()
    /// The node for the z axis title.
    var zAxisTitleNode = SCNNode()
    
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
    
    // Highlights
    /// The radius of each highlight that connects a point to each plane.
    var highlightRadius: CGFloat = 0.01
    /// The color of each highlight that connects a point to each plane.
    var highlightColor: UIColor = .yellow
    /// The root node of all of the highlight nodes.
    private var highlightRootNode: SCNNode
    /// A dictionary keeping track of which nodes are already highlighted.
    private var highlightedIndexes = [Int:Bool]()
    
    // Connections
    /// All of the nodes of the connections that are added on the plot.
    private var connectionNodes = [SCNNode]()
    /// The root node of all of the plotted connections.
    private var connectionRootNode: SCNNode
    
    // MARK: - Init
    
    /**
     Initialize a `PlotSpaceNode` with the given configuration.
     - parameter config: The configuration that defines the attributes to use.
     */
    init(config: PlotConfiguration) {
        
        xAxisHeight = config.xAxisHeight
        yAxisHeight = config.yAxisHeight
        zAxisHeight = config.zAxisHeight
        axisRadius = config.axisRadius
        gridlineRadius = config.gridlineRadius
        xAxis = SCNCylinder(radius: axisRadius, height: xAxisHeight)
        yAxis = SCNCylinder(radius: axisRadius, height: yAxisHeight)
        zAxis = SCNCylinder(radius: axisRadius, height: zAxisHeight)
        
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
                                                    axisHeight: config.xAxisHeight)
        let yGridSpacing = PlotSpaceNode.coordinate(forValue: config.yTickInterval,
                                                    axisMaxValue: config.yMax,
                                                    axisMinValue: config.yMin,
                                                    axisHeight: config.yAxisHeight)
        let zGridSpacing = PlotSpaceNode.coordinate(forValue: config.zTickInterval,
                                                    axisMaxValue: config.zMax,
                                                    axisMinValue: config.zMin,
                                                    axisHeight: config.zAxisHeight)
        
        unitPlaneXY = SCNPlane(width: xGridSpacing, height: yGridSpacing)
        unitPlaneXZ = SCNPlane(width: xGridSpacing, height: zGridSpacing)
        unitPlaneYZ = SCNPlane(width: zGridSpacing, height: yGridSpacing)
        unitPlaneXYNode = SCNNode(geometry: unitPlaneXY)
        unitPlaneXZNode = SCNNode(geometry: unitPlaneXZ)
        unitPlaneYZNode = SCNNode(geometry: unitPlaneYZ)
        
        wallXY = SCNBox(width: xAxisHeight, height: yAxisHeight, length: config.planeThickness, chamferRadius: 0)
        wallXZ = SCNBox(width: xAxisHeight, height: zAxisHeight, length: config.planeThickness, chamferRadius: 0)
        wallYZ = SCNBox(width: zAxisHeight, height: yAxisHeight, length: config.planeThickness, chamferRadius: 0)
        wallXYNode = SCNNode(geometry: wallXY)
        wallXZNode = SCNNode(geometry: wallXZ)
        wallYZNode = SCNNode(geometry: wallYZ)
        
        plotPointRootNode = SCNNode()
        highlightRootNode = SCNNode()
        connectionRootNode = SCNNode()
        
        xMax = config.xMax
        yMax = config.yMax
        zMax = config.zMax
        xMin = config.xMin
        yMin = config.yMin
        zMin = config.zMin
                
        super.init()
        
        setupAxis()
        setupUnitPlanes(xGridSpacing: xGridSpacing, yGridSpacing: yGridSpacing, zGridSpacing: zGridSpacing, config: config)
        
        // xy grid lines
        gridLinesHorizontalXY += addGridLines(rootNode: xAxisNode, spacing: yGridSpacing, direction: PlotAxis.x.negativeDirection, color: config.xyGridColor, axisHeight: yAxisHeight, axisLength: xAxisHeight)
        gridLinesVerticalXY += addGridLines(rootNode: yAxisNode, spacing: xGridSpacing, direction: PlotAxis.x.direction, color: config.xyGridColor, axisHeight: xAxisHeight, axisLength: yAxisHeight)
        // xz grid lines
        gridLinesHorizontalXZ += addGridLines(rootNode: xAxisNode, spacing: zGridSpacing, direction: PlotAxis.z.direction, color: config.xzGridColor, axisHeight: zAxisHeight, axisLength: xAxisHeight)
        gridLinesVerticalXZ += addGridLines(rootNode: zAxisNode, spacing: xGridSpacing, direction: PlotAxis.x.direction, color: config.xzGridColor, axisHeight: xAxisHeight, axisLength: zAxisHeight)
        // yz grid lines
        gridLinesVerticalYZ += addGridLines(rootNode: yAxisNode, spacing: zGridSpacing, direction: PlotAxis.z.direction, color: config.yzGridColor, axisHeight: zAxisHeight, axisLength: yAxisHeight)
        gridLinesHorizontalYZ += addGridLines(rootNode: zAxisNode, spacing: yGridSpacing, direction: PlotAxis.z.negativeDirection, color: config.yzGridColor, axisHeight: yAxisHeight, axisLength: zAxisHeight)
        
        addWall(plane: .xy, color: config.xyPlaneColor)
        addWall(plane: .xz, color: config.xzPlaneColor)
        addWall(plane: .yz, color: config.yzPlaneColor)
        
        addChildNode(plotPointRootNode)
        addChildNode(highlightRootNode)
        addChildNode(connectionRootNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    /**
     Sets up each axis and adds them as a child node.
     - parameter axisHeight: The height of each axis.
     */
    private func setupAxis() {
        xAxisNode.position = SCNVector3(xAxisHeight/2, 0, 0)
        xAxisNode.eulerAngles = SCNVector3(0, 0, -Double.pi/2)
        xArrowNode.position = SCNVector3(0, xAxisHeight/2, 0)
        xAxisNode.addChildNode(xArrowNode)
        addChildNode(xAxisNode)

        yAxisNode.position = SCNVector3(0, yAxisHeight/2, 0)
        yArrowNode.position = SCNVector3(0, yAxisHeight/2, 0)
        yAxisNode.addChildNode(yArrowNode)
        addChildNode(yAxisNode)
        
        zAxisNode.position = SCNVector3(0, 0, zAxisHeight/2)
        zAxisNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
        zArrowNode.position = SCNVector3(0, zAxisHeight/2, 0)
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
        - axisHeight: The scene height of the axis.
     - returns: The array of nodes that contains the gridlines that were added.
    */
    private func addGridLines(rootNode: SCNNode, spacing: CGFloat, direction: SCNVector3, color: UIColor, axisHeight: CGFloat, axisLength: CGFloat) -> [SCNNode] {
        let lineCount = Int(axisHeight/spacing)
        var gridLines = [SCNNode]()
        for i in 0..<lineCount {
            let gridLine = SCNCylinder(radius: gridlineRadius, height: axisLength)
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
     Updates the gridline tick marks by first removing the existing ones, and then delegating to the instances plot delegate to add new tick marks.
     */
    private func updateTickMarks() {
        xTickMarksNode.removeFromParentNode()
        yTickMarksNode.removeFromParentNode()
        zTickMarksNode.removeFromParentNode()
        
        xTickMarksNode = SCNNode()
        yTickMarksNode = SCNNode()
        zTickMarksNode = SCNNode()
        
        addChildNode(xTickMarksNode)
        addChildNode(yTickMarksNode)
        addChildNode(zTickMarksNode)
        
        guard let delegate = delegate else {
            return
        }
        
        // x
        for (index, gridline) in gridLinesVerticalXZ.enumerated() {
            let position = gridline.position.x
            guard let text = delegate.plot(plotView!, textAtTickMark: index, forAxis: .x) else {
                continue
            }
            let textNode = text.node
            textNode.eulerAngles = tickMarkTextRotation(forAxis: .x)
            textNode.position = SCNVector3(CGFloat(position), 0, zAxisHeight + text.offset)
            xTickMarksNode.addChildNode(textNode)
        }
        
        // y
        for (index, gridline) in gridLinesHorizontalYZ.enumerated() {
            let position = -gridline.position.z
            guard let text = delegate.plot(plotView!, textAtTickMark: index, forAxis: .y) else {
                continue
            }
            let textNode = text.nodeRightAligned
            textNode.eulerAngles = tickMarkTextRotation(forAxis: .y)
            textNode.position = SCNVector3(0, CGFloat(position), zAxisHeight + text.offset)
            yTickMarksNode.addChildNode(textNode)
        }
        
        // z
        for (index, gridline) in gridLinesHorizontalXZ.enumerated() {
            let position = gridline.position.z
            guard let text = delegate.plot(plotView!, textAtTickMark: index, forAxis: .z) else {
                continue
            }
            let textNode = text.node
            textNode.eulerAngles = tickMarkTextRotation(forAxis: .z)
            textNode.position = SCNVector3(xAxisHeight + text.offset, 0, CGFloat(position))
            zTickMarksNode.addChildNode(textNode)
        }
    }
    
    /**
     Adds the wall for the given plane.
     - parameters:
        - plane: The plane for the wall to be added on.
        - color: The color of the wall go add.
     */
    private func addWall(plane: PlotPlane, color: UIColor) {
        setWall(plane, color: color)
        
        var axisW: CGFloat
        var axisH: CGFloat
        
        switch plane {
        case .xy:
            axisW = xAxisHeight
            axisH = yAxisHeight
        case .xz:
            axisW = xAxisHeight
            axisH = zAxisHeight
        case .yz:
            axisW = yAxisHeight
            axisH = zAxisHeight
        }
        
        let offsetW = axisW/2
        let offsetH = axisH/2
        var wallNode: SCNNode
        switch plane {
        case .xy:
            wallNode = wallXYNode
            wallNode.position = SCNVector3(offsetW, offsetH, 0)
        case .xz:
            wallNode = wallXZNode
            wallNode.eulerAngles = SCNVector3(-Double.pi/2, 0, 0)
            wallNode.position = SCNVector3(offsetW, 0, offsetH)
        case .yz:
            wallNode = wallYZNode
            wallNode.eulerAngles = SCNVector3(0, Double.pi/2, 0)
            wallNode.position = SCNVector3(0, offsetW, offsetH)
        }
        
        addChildNode(wallNode)
    }
    
    // MARK: - Plotting
    
    /**
     Connects the nodes corresponding to the given index.
     - parameters:
        - index0: The index of the node where the connection begins.
        - index1: The index of the node where the connection ends.
        - connection: The attributes for the connection.
     
     */
    func connectPoints(index0: Int, index1: Int, connection: PlotConnection) {
        let node0 = plottedPoints[index0]
        let node1 = plottedPoints[index1]
        let diffVector = node1.position - node0.position
        
        let connectionLength = CGFloat(diffVector.length())
        let connectionGeometry = SCNCylinder(radius: connection.radius, height: connectionLength)
        connectionGeometry.materials.first!.diffuse.contents = connection.color
        
        let connectionNode = SCNNode(geometry: connectionGeometry)
        connectionNode.position = node0.position.midPoint(to: node1.position)
        connectionNode.eulerAngles = node0.position.eulerAngles(to: node1.position)
        
        connectionNodes.append(connectionNode)
        connectionRootNode.addChildNode(connectionNode)
    }
    
    /**
     Calculates the scene coordinate for a value on an axis in a plot space.
     - parameters:
        - value: The value to convert to a scene coordinate.
        - axisMaxValue: The max value of the axis.
        - axisMinValue: The min value of the axis.
        - axisHeight: the scene height of the axis.
     
     - returns: The float that corresponds to a coordinate on an axis in the scene.
     */
    private static func coordinate(forValue value: CGFloat, axisMaxValue: CGFloat, axisMinValue: CGFloat, axisHeight: CGFloat) -> CGFloat {
        return value * (axisHeight/(axisMaxValue - axisMinValue))
    }
    
    /**
     Plots the given point of raw data into the scene.
     
     The given point should not be modified for the scene.
     The plot point will be converted to scene coordinate using `self.coordinate(_:)`.
     
     - parameters:
        - point: The raw data point to plot.
        - geometry: The geometry of the node plotted in the scene for the given coordinate.
     
     */
    private func plot(_ point: PlotPoint, geometry: SCNGeometry?) {
        let pointNode = PlotPointNode(geometry: geometry, index: plottedPoints.count)
        let x = PlotSpaceNode.coordinate(forValue: point.x, axisMaxValue: xMax, axisMinValue: xMin, axisHeight: xAxisHeight)
        let y = PlotSpaceNode.coordinate(forValue: point.y, axisMaxValue: yMax, axisMinValue: yMin, axisHeight: yAxisHeight)
        let z = PlotSpaceNode.coordinate(forValue: point.z, axisMaxValue: zMax, axisMinValue: zMin, axisHeight: zAxisHeight)
        pointNode.position = SCNVector3(x, y, z)
        
        plottedPoints.append(pointNode)
        plotPointRootNode.addChildNode(pointNode)
    }
    
    /**
     Safely returns the node plotted at the given index.
     - parameter index: the index of that plotted node.
     - returns: an optional reference to the `SCNNode` that is plotted at the given index.
     */
    func plottedPoint(atIndex index: Int) -> SCNNode? {
        guard index < plottedPoints.count, index >= 0 else {
            return nil
        }
        
        return plottedPoints[index]
    }
    
    // MARK: - Update Plot
    
    /**
     Adds any new connections that might be required after the last call to `PlotNewPoints`.
     
     This function is intended for cases where most of the data has already been plotted, and only a relatively lesser amount of additional connections need to be added.
     */
    func addNewConnections() {
        guard let dataSource = dataSource, let delegate = delegate, let plotView = plotView else {
            return
        }
        
        let currentConnectionCount = connectionNodes.count
        let additionalConnectionCount = dataSource.numberOfConnections() - currentConnectionCount
        
        guard additionalConnectionCount > 0 else {
            return
        }
        
        let startIndex = currentConnectionCount
        for index in startIndex..<startIndex+additionalConnectionCount {
            guard let pointsToConnect = delegate.plot(plotView, pointsToConnectAt: index),
                let connection = delegate.plot(plotView, connectionAt: index)
                else {
                continue
            }
            connectPoints(index0: pointsToConnect.p0, index1: pointsToConnect.p1, connection: connection)
        }
    }
    
    /**
     Plots any points that were added aftter the latest call to `plotNewPoints`.
     
     This function is intended for cases where most of the data has already been plotted, and only a relatively lesser amount of additional points need to be plotted.
     */
    func addNewPlotPoints() {
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
    
    /**
     Reloads all of the connections that need to be added to the plot.
     - parameter numberOfConnections: The number of connections that need to be added.
     */
    func reloadConnections(_ numberOfConnections: Int) {
        guard let delegate = delegate, let plotView = plotView, numberOfConnections > 0 else {
            return
        }
        
        for index in 0..<numberOfConnections {
            guard let pointsToConnect = delegate.plot(plotView, pointsToConnectAt: index),
                let connection = delegate.plot(plotView, connectionAt: index)
                else {
                continue
            }
            connectPoints(index0: pointsToConnect.p0, index1: pointsToConnect.p1, connection: connection)
        }
    }
    
    /**
    Reloads all of the plot points that need to be added to the plot.
    - parameter numberOfPoints: The number of points that need to be added.
    */
    func reloadPlottedPoints(_ numberOfPoints: Int) {
        guard let delegate = delegate, let plotView = plotView, numberOfPoints > 0 else {
            return
        }
        
        for index in 0..<numberOfPoints {
            let plotPoint = delegate.plot(plotView, pointForItemAt: index)
            let geometry = delegate.plot(plotView, geometryForItemAt: index)
            plot(plotPoint, geometry: geometry)
        }
    }
    
    /**
     Reloads the plotted points using the plot data source and plot delegate.
     
     This function is analagous to a `UITableView`'s `reloadData()` function.
     It will remove all tick marks and all plotted points, and then add new tick marks using its delegate, and plot the new data using the delegate and datasource.
     */
    func reloadData() {
        removeAllPlottedPoints()
        updateTickMarks()
        
        guard let dataSource = dataSource else {
            return
        }
        
        let numberOfPoints = dataSource.numberOfPoints()
        reloadPlottedPoints(numberOfPoints)
        
        let numberOfConnections = dataSource.numberOfConnections()
        reloadConnections(numberOfConnections)
    }
    
    /**
     Removes all of the plotted points from the `PlotSpaceNode` and removes all of the nodes stored in `plottedPoints`.
     Removes all of the connections from the `PlotSpaceNode` and removes all of the nodes stored in `connectionNodes`.
     */
    private func removeAllPlottedPoints() {
        plottedPoints.removeAll()
        plotPointRootNode.removeFromParentNode()
        plotPointRootNode = SCNNode()
        addChildNode(plotPointRootNode)
        
        connectionNodes.removeAll()
        connectionRootNode.removeFromParentNode()
        connectionRootNode = SCNNode()
        addChildNode(connectionRootNode)
    }
    
    /**
     Adds cyclinders that connect the given node to each plane.  Nodes can be highlighted to help the user better see where the node is on the plot.
     - parameter node: The node that is selected for highlight.
     */
    func highlightNode(_ node: PlotPointNode) {
        guard highlightedIndexes[node.index] != true else {
            return
        }
        
        highlightedIndexes[node.index] = true
        let xHighlightGeometry = SCNCylinder(radius: highlightRadius, height: CGFloat(abs(node.position.z)))
        xHighlightGeometry.materials.first!.diffuse.contents = highlightColor
        let xHighlightNode = SCNNode(geometry: xHighlightGeometry)
        xHighlightNode.position = SCNVector3(node.position.x, node.position.y, node.position.z/2)
        xHighlightNode.eulerAngles = highlightRotation(forAxis: .x)
        highlightRootNode.addChildNode(xHighlightNode)
        
        let yHighlightGeometry = SCNCylinder(radius: highlightRadius, height: CGFloat(abs(node.position.x)))
        yHighlightGeometry.materials.first!.diffuse.contents = highlightColor
        let yHighlightNode = SCNNode(geometry: yHighlightGeometry)
        yHighlightNode.position = SCNVector3(node.position.x/2, node.position.y, node.position.z)
        yHighlightNode.eulerAngles = highlightRotation(forAxis: .y)
        highlightRootNode.addChildNode(yHighlightNode)
        
        let zHighlightGeometry = SCNCylinder(radius: highlightRadius, height: CGFloat(abs(node.position.y)))
        zHighlightGeometry.materials.first!.diffuse.contents = highlightColor
        let zHighlightNode = SCNNode(geometry: zHighlightGeometry)
        zHighlightNode.position = SCNVector3(node.position.x, node.position.y/2, node.position.z)
        zHighlightNode.eulerAngles = highlightRotation(forAxis: .z)
        highlightRootNode.addChildNode(zHighlightNode)
    }
    
    /**
     Replaces the `highlightRootNode` with a new node that has no children, and removes all of the stored highlighted indexes.
     */
    func removeHighlights() {
        highlightedIndexes.removeAll()
        highlightRootNode.removeFromParentNode()
        highlightRootNode = SCNNode()
        addChildNode(highlightRootNode)
    }
    
    // MARK: Update Configuration
    
    /**
     Sets the value of `isHidden` for the unit plane on the given `PlotPlane`.
     - parameters:
        - plane: The plane that contains the unit plane is intended for.
        - isHidden: Whether or not the unit plane should be hidden.
     */
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
    
    /**
    Sets the value of `isHidden` for the wall on the given `PlotPlane`.
    - parameters:
       - plane: The plane that contains the unit plane is intended for.
       - isHidden: Whether or not the wall should be hidden.
    */
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
    
    /**
    Sets the color for the wall on the given `PlotPlane`.
    - parameters:
       - plane: The plane that contains the unit plane is intended for.
       - color: The color for the wall.
    */
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
    
    // MARK: - Labels

    /**
     Sets a title for the given axis.
     - parameters:
        - axis: The axis to set a title for.
        - plotText: The PlotText object to use to generate the node for the axis title.
    */
    func setAxisTitle(_ axis: PlotAxis,
                      plotText: PlotText) {
        var axisTitleNode: SCNNode
        var axisHeight: CGFloat
        var axisPosition: CGFloat
        switch axis {
        case .x:
            axisHeight = zAxisHeight
            axisPosition = xAxisHeight
        case .y:
            axisHeight = zAxisHeight
            axisPosition = yAxisHeight
        case .z:
            axisHeight = xAxisHeight
            axisPosition = zAxisHeight
        }
        
        let axisAndOffset = plotText.offset + axisHeight
        switch axis {
        case .x:
            xAxisTitleNode.removeFromParentNode()
            xAxisTitleNode = plotText.node
            axisTitleNode = xAxisTitleNode
            axisTitleNode.position = SCNVector3((axisPosition)/2, 0, axisAndOffset)
        case .y:
            yAxisTitleNode.removeFromParentNode()
            yAxisTitleNode = plotText.node
            axisTitleNode = yAxisTitleNode
            axisTitleNode.position = SCNVector3(0, (axisPosition)/2, axisAndOffset)
            
        case .z:
            zAxisTitleNode.removeFromParentNode()
            zAxisTitleNode = plotText.node
            axisTitleNode = zAxisTitleNode
            axisTitleNode.position = SCNVector3(axisAndOffset, 0, (axisPosition)/2)
        }
        
        axisTitleNode.eulerAngles = axisTextRotation(forAxis: axis)
        addChildNode(axisTitleNode)
    }
    
    func axisTextRotation(forAxis axis: PlotAxis) -> SCNVector3 {
        switch axis {
        case .x:
            return SCNVector3(-Double.pi/2, 0, 0)
        case .y:
           return SCNVector3(-Double.pi/2, 0, -Double.pi/2)
        case .z:
            return SCNVector3(-Double.pi/2, Double.pi/2, 0)
        }
    }
    
    func highlightRotation(forAxis axis: PlotAxis) -> SCNVector3 {
        switch axis {
        case .x:
            return SCNVector3(-Double.pi/2, 0, 0)
        case .y:
           return SCNVector3(0, 0, -Double.pi/2)
        case .z:
            return SCNVector3(0, 0, 0)
        }
    }
    
    func tickMarkTextRotation(forAxis axis: PlotAxis) -> SCNVector3 {
        switch axis {
        case .x:
            return SCNVector3(-Double.pi/2, 0, 0)
        case .y:
           return SCNVector3(-Double.pi/2, Double.pi/2, -Double.pi/2)
        case .z:
            return SCNVector3(-Double.pi/2, Double.pi/2, 0)
        }
    }
    
}
