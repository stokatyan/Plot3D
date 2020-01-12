//
//  PlotSpaceNode.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 12/19/19.
//  Copyright © 2019 Stokaty. All rights reserved.
//

import SceneKit

public class PlotSpaceNode: SCNNode {
    
    // MARK: - Properties
    
    // Axis
    let axisHeight: CGFloat
    let axisRadius: CGFloat
    let gridlineRadius: CGFloat
    let xAxis: SCNGeometry
    let yAxis: SCNGeometry
    let zAxis: SCNGeometry
    let xPlotSpaceNode: SCNNode
    let yPlotSpaceNode: SCNNode
    let zPlotSpaceNode: SCNNode
    let originGeometry: SCNGeometry
    
    // Axis Arrows
    let xAxisArrow: SCNGeometry
    let yAxisArrow: SCNGeometry
    let zAxisArrow: SCNGeometry
    let xArrowNode: SCNNode
    let yArrowNode: SCNNode
    let zArrowNode: SCNNode
    
    // Planes
    let unitPlaneXY: SCNGeometry
    let unitPlaneXZ: SCNGeometry
    let unitPlaneYZ: SCNGeometry
    let unitPlaneXYNode: SCNNode
    let unitPlaneXZNode: SCNNode
    let unitPlaneYZNode: SCNNode
    
    let wallXY: SCNGeometry
    let wallXZ: SCNGeometry
    let wallYZ: SCNGeometry
    let wallXYNode: SCNNode
    let wallXZNode: SCNNode
    let wallYZNode: SCNNode
    
    public private(set) var gridLinesHorizontalXY = [SCNNode]()
    public private(set) var gridLinesHorizontalXZ = [SCNNode]()
    public private(set) var gridLinesHorizontalYZ = [SCNNode]()
    public private(set) var gridLinesVerticalXY = [SCNNode]()
    public private(set) var gridLinesVerticalXZ = [SCNNode]()
    public private(set) var gridLinesVerticalYZ = [SCNNode]()
    
    private var xMax: CGFloat
    private var yMax: CGFloat
    private var zMax: CGFloat
    private var xMin: CGFloat
    private var yMin: CGFloat
    private var zMin: CGFloat
    
    // Plotting
    private var plotPointRootNode: SCNNode
    private var plottedPoints = [SCNNode]()
    var dataSource: PlotDataSource?
    var delegate: PlotDelegate?
    
    // MARK: - Init
    
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
        
        xPlotSpaceNode = SCNNode(geometry: xAxis)
        yPlotSpaceNode = SCNNode(geometry: yAxis)
        zPlotSpaceNode = SCNNode(geometry: zAxis)
        
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
        
        wallXY = SCNBox(width: axisHeight, height: axisHeight, length: config.wallThickness, chamferRadius: 0)
        wallXZ = SCNBox(width: axisHeight, height: axisHeight, length: config.wallThickness, chamferRadius: 0)
        wallYZ = SCNBox(width: axisHeight, height: axisHeight, length: config.wallThickness, chamferRadius: 0)
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
        gridLinesHorizontalXY += addGridLines(rootNode: xPlotSpaceNode, spacing: yGridSpacing, direction: PlotAxis.x.negativeDirection, color: config.xyGridColor)
        gridLinesVerticalXY += addGridLines(rootNode: yPlotSpaceNode, spacing: xGridSpacing, direction: PlotAxis.x.direction, color: config.xyGridColor)
        // xz grid lines
        gridLinesHorizontalXZ += addGridLines(rootNode: xPlotSpaceNode, spacing: zGridSpacing, direction: PlotAxis.z.direction, color: config.xzGridColor)
        gridLinesVerticalXZ += addGridLines(rootNode: zPlotSpaceNode, spacing: xGridSpacing, direction: PlotAxis.x.direction, color: config.xzGridColor)
        // yz grid lines
        gridLinesVerticalYZ += addGridLines(rootNode: yPlotSpaceNode, spacing: zGridSpacing, direction: PlotAxis.z.direction, color: config.yzGridColor)
        gridLinesHorizontalYZ += addGridLines(rootNode: zPlotSpaceNode, spacing: yGridSpacing, direction: PlotAxis.z.negativeDirection, color: config.yzGridColor)
        
        addWall(plane: .xy, color: config.xyWallColor)
        addWall(plane: .xz, color: config.xzWallColor)
        addWall(plane: .yz, color: config.yzWallColor)
        
        addChildNode(plotPointRootNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupAxis(axisHeight: CGFloat) {
        xPlotSpaceNode.position = SCNVector3(axisHeight/2, 0, 0)
        xPlotSpaceNode.eulerAngles = SCNVector3(0, 0, -Double.pi/2)
        xArrowNode.position = SCNVector3(0, axisHeight/2, 0)
        xPlotSpaceNode.addChildNode(xArrowNode)
        addChildNode(xPlotSpaceNode)

        yPlotSpaceNode.position = SCNVector3(0, axisHeight/2, 0)
        yArrowNode.position = SCNVector3(0, axisHeight/2, 0)
        yPlotSpaceNode.addChildNode(yArrowNode)
        addChildNode(yPlotSpaceNode)
        
        zPlotSpaceNode.position = SCNVector3(0, 0, axisHeight/2)
        zPlotSpaceNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
        zArrowNode.position = SCNVector3(0, axisHeight/2, 0)
        zPlotSpaceNode.addChildNode(zArrowNode)
        addChildNode(zPlotSpaceNode)

        originGeometry.materials.first!.diffuse.contents = UIColor.white
        let originNode = SCNNode(geometry: originGeometry)
        originNode.position = SCNVector3(0, 0, 0)
        addChildNode(originNode)
    }
    
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
        let pointNode = SCNNode(geometry: geometry)
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
        guard let dataSource = dataSource, let delegate = delegate else {
            return
        }
        
        let currentPointCount = plottedPoints.count
        let additionalPointCount = dataSource.numberOfPoints() - currentPointCount
        
        guard additionalPointCount > 0 else {
            return
        }
        
        let startIndex = currentPointCount
        for index in 0..<additionalPointCount {
            let plotPoint = delegate.plot(self, pointForItemAt: index + startIndex)
            let geometry = delegate.plot(self, geometryForItemAt: index + startIndex)
            plot(plotPoint, geometry: geometry)
        }
    }
    
    func refresh() {
        removeAllPlottedPoints()
        
        guard let dataSource = dataSource, let delegate = delegate else {
            return
        }
        
        let numberOfPoints = dataSource.numberOfPoints()
        guard numberOfPoints > 0 else {
            return
        }
        
        for index in 0..<numberOfPoints {
            let plotPoint = delegate.plot(self, pointForItemAt: index)
            let geometry = delegate.plot(self, geometryForItemAt: index)
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
