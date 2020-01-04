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
    let planeXY: SCNGeometry
    let planeXZ: SCNGeometry
    let planeYZ: SCNGeometry
    let planeXYNode: SCNNode
    let planeXZNode: SCNNode
    let planeYZNode: SCNNode
    
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
        
        planeXY = SCNPlane(width: xGridSpacing, height: yGridSpacing)
        planeXZ = SCNPlane(width: xGridSpacing, height: zGridSpacing)
        planeYZ = SCNPlane(width: zGridSpacing, height: yGridSpacing)
        
        planeXYNode = SCNNode(geometry: planeXY)
        planeXZNode = SCNNode(geometry: planeXZ)
        planeYZNode = SCNNode(geometry: planeYZ)
        
        super.init()
        
        setupAxis(axisHeight: axisHeight)
        setupPlanes(xGridSpacing: xGridSpacing, yGridSpacing: yGridSpacing, zGridSpacing: zGridSpacing)

        let xyGridColor = config.xyGridColor
        let xzGridColor = config.xzGridColor
        let yzGridColor = config.yzGridColor
        setupGridLines(rootNode: xPlotNode, spacing: yGridSpacing, direction: SCNVector3(-1, 0, 0), color: xyGridColor)
        setupGridLines(rootNode: yPlotNode, spacing: xGridSpacing, direction: SCNVector3(1, 0, 0), color: xyGridColor)

        setupGridLines(rootNode: xPlotNode, spacing: zGridSpacing, direction: SCNVector3(0, 0, 1), color: xzGridColor)
        setupGridLines(rootNode: zPlotNode, spacing: xGridSpacing, direction: SCNVector3(1, 0, 0), color: xzGridColor)

        setupGridLines(rootNode: yPlotNode, spacing: zGridSpacing, direction: SCNVector3(0, 0, 1), color: yzGridColor)
        setupGridLines(rootNode: zPlotNode, spacing: yGridSpacing, direction: SCNVector3(0, 0, -1), color: yzGridColor)
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupAxis(axisHeight: CGFloat) {
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
    
    func setupPlanes(xGridSpacing: CGFloat, yGridSpacing: CGFloat, zGridSpacing: CGFloat) {
        let xOffset = xGridSpacing/2
        let yOffset = yGridSpacing/2
        let zOffset = zGridSpacing/2
        
        planeXY.materials.first!.diffuse.contents = UIColor.red.withAlphaComponent(0.5)
        planeXYNode.position = SCNVector3(xOffset, yOffset, 0)
        addChildNode(planeXYNode)
        
        planeXZ.materials.first!.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
        planeXZNode.eulerAngles = SCNVector3(-Double.pi/2, 0, 0)
        planeXZNode.position = SCNVector3(xOffset, 0, zOffset)
        addChildNode(planeXZNode)
        
        planeYZ.materials.first!.diffuse.contents = UIColor.yellow.withAlphaComponent(0.5)
        planeYZNode.eulerAngles = SCNVector3(0, Double.pi/2, 0)
        planeYZNode.position = SCNVector3(0, yOffset, zOffset)
        addChildNode(planeYZNode)
    }
    
    func setupGridLines(rootNode: SCNNode, spacing: CGFloat, direction: SCNVector3, color: UIColor) {
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
    
    // MARK: - Plotting
    
    static func coordinate(forValue value: CGFloat, axisMaxValue: CGFloat, axisMinValue: CGFloat, axisHeight: CGFloat) -> CGFloat {
        return value * (axisHeight/(axisMaxValue - axisMinValue))
    }
    
    func coordinate(forValue value: CGFloat, axisMaxValue: CGFloat, axisMinValue: CGFloat) -> CGFloat {
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
    
    func plot(points: [PlotPoint]) {
        plot(points: points.map({ point -> SCNVector3 in
            return point.vector
        }))
    }
    
}
