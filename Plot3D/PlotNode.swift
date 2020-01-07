//
//  PlotNode.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 12/19/19.
//  Copyright © 2019 Stokaty. All rights reserved.
//

import SceneKit

class PlotNode: SCNNode {
    
    // MARK: - Properties
    
    // Axis
    let axisHeight: CGFloat
    let axisRadius: CGFloat
    let gridlineRadius: CGFloat
    let xAxis: SCNGeometry
    let yAxis: SCNGeometry
    let zAxis: SCNGeometry
    let xPlotNode: SCNNode
    let yPlotNode: SCNNode
    let zPlotNode: SCNNode
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
    let xyPlaneNode = SCNNode()
    let xzPlaneNode = SCNNode()
    let yzPlaneNode = SCNNode()
    
    // Grid
    var gridXY = [SCNGeometry]()
    
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
        
        xPlotNode = SCNNode(geometry: xAxis)
        yPlotNode = SCNNode(geometry: yAxis)
        zPlotNode = SCNNode(geometry: zAxis)
        
        xArrowNode = SCNNode(geometry: xAxisArrow)
        yArrowNode = SCNNode(geometry: yAxisArrow)
        zArrowNode = SCNNode(geometry: zAxisArrow)
        
        originGeometry = SCNSphere(radius: axisRadius)
                
        let xGridSpacing = PlotNode.coordinate(forValue: config.xTickInterval,
                                               axisMaxValue: config.xMax,
                                               axisMinValue: config.xMin,
                                               axisHeight: config.axisHeight)
        let yGridSpacing = PlotNode.coordinate(forValue: config.yTickInterval,
                                               axisMaxValue: config.yMax,
                                               axisMinValue: config.yMin,
                                               axisHeight: config.axisHeight)
        let zGridSpacing = PlotNode.coordinate(forValue: config.zTickInterval,
                                               axisMaxValue: config.zMax,
                                               axisMinValue: config.zMin,
                                               axisHeight: config.axisHeight)
        
        unitPlaneXY = SCNPlane(width: xGridSpacing, height: yGridSpacing)
        unitPlaneXZ = SCNPlane(width: xGridSpacing, height: zGridSpacing)
        unitPlaneYZ = SCNPlane(width: zGridSpacing, height: yGridSpacing)
        unitPlaneXYNode = SCNNode(geometry: unitPlaneXY)
        unitPlaneXZNode = SCNNode(geometry: unitPlaneXZ)
        unitPlaneYZNode = SCNNode(geometry: unitPlaneYZ)
        
        super.init()
        
        setupAxis(axisHeight: axisHeight)
        setupUnitPlanes(xGridSpacing: xGridSpacing, yGridSpacing: yGridSpacing, zGridSpacing: zGridSpacing, config: config)
        
        // xy plane
        addGridLines(rootNode: xPlotNode, spacing: yGridSpacing, direction: PlotAxis.x.negativeDirection, color: config.xyGridColor)
        addGridLines(rootNode: yPlotNode, spacing: xGridSpacing, direction: PlotAxis.x.direction, color: config.xyGridColor)
        // xz plane
        addGridLines(rootNode: xPlotNode, spacing: zGridSpacing, direction: PlotAxis.z.direction, color: config.xzGridColor)
        addGridLines(rootNode: zPlotNode, spacing: xGridSpacing, direction: PlotAxis.x.direction, color: config.xzGridColor)
        // yz plane
        addGridLines(rootNode: yPlotNode, spacing: zGridSpacing, direction: PlotAxis.z.direction, color: config.yzGridColor)
        addGridLines(rootNode: zPlotNode, spacing: yGridSpacing, direction: PlotAxis.z.negativeDirection, color: config.yzGridColor)
        
        addWall(plane: .xy, color: config.xyGridColor.withAlphaComponent(0.25), wallThickness: config.wallThickness)
        addWall(plane: .xz, color: config.xzGridColor.withAlphaComponent(0.25), wallThickness: config.wallThickness)
        addWall(plane: .yz, color: config.yzGridColor.withAlphaComponent(0.25), wallThickness: config.wallThickness)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupAxis(axisHeight: CGFloat) {
        xPlotNode.position = SCNVector3(axisHeight/2, 0, 0)
        xPlotNode.eulerAngles = SCNVector3(0, 0, -Double.pi/2)
        xArrowNode.position = SCNVector3(0, axisHeight/2, 0)
        xPlotNode.addChildNode(xArrowNode)
        addChildNode(xPlotNode)

        yPlotNode.position = SCNVector3(0, axisHeight/2, 0)
        yArrowNode.position = SCNVector3(0, axisHeight/2, 0)
        yPlotNode.addChildNode(yArrowNode)
        addChildNode(yPlotNode)
        
        zPlotNode.position = SCNVector3(0, 0, axisHeight/2)
        zPlotNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
        zArrowNode.position = SCNVector3(0, axisHeight/2, 0)
        zPlotNode.addChildNode(zArrowNode)
        addChildNode(zPlotNode)

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
    
    private func addGridLines(rootNode: SCNNode, spacing: CGFloat, direction: SCNVector3, color: UIColor) {
        let lineCount = Int(axisHeight/spacing)
        for i in 0..<lineCount {
            let gridLine = SCNCylinder(radius: gridlineRadius, height: axisHeight)
            gridLine.materials.first!.diffuse.contents = color
            let gridLineNode = SCNNode(geometry: gridLine)
            let position = spacing * CGFloat(i + 1)
            gridLineNode.position = SCNVector3(position, position, position) * direction
            rootNode.addChildNode(gridLineNode)
        }
    }
    
    private func addWall(plane: PlotPlane, color: UIColor, wallThickness: CGFloat) {
        let wallGeometry = SCNBox(width: axisHeight, height: axisHeight, length: wallThickness, chamferRadius: 0)
        wallGeometry.materials.first!.diffuse.contents = color
        let wallNode = SCNNode(geometry: wallGeometry)
        
        let offset = axisHeight/2
        switch plane {
        case .xy:
            wallNode.position = SCNVector3(offset, offset, 0)
        case .xz:
            wallNode.eulerAngles = SCNVector3(-Double.pi/2, 0, 0)
            wallNode.position = SCNVector3(offset, 0, offset)
        case .yz:
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
        return PlotNode.coordinate(forValue: value, axisMaxValue: axisMaxValue, axisMinValue: axisMinValue, axisHeight: self.axisHeight)
    }
    
    func plot(points: [SCNVector3]) {
        for point in points {
            let plotShape = SCNSphere(radius: 0.1)
            let pointNode = SCNNode(geometry: plotShape)
            let x = coordinate(forValue: CGFloat(point.x), axisMaxValue: 10, axisMinValue: 0)
            let y = coordinate(forValue: CGFloat(point.y), axisMaxValue: 10, axisMinValue: 0)
            let z = coordinate(forValue: CGFloat(point.z), axisMaxValue: 10, axisMinValue: 0)
            pointNode.position = SCNVector3(x, y, z)
            addChildNode(pointNode)
        }
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
    
}
