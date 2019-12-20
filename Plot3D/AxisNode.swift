//
//  AxisNode.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 12/19/19.
//  Copyright © 2019 Stokaty. All rights reserved.
//

import SceneKit

class AxisNode: SCNNode {
    
    // MARK: - Properties
    
    // Axis
    let xAxis: SCNGeometry
    let yAxis: SCNGeometry
    let zAxis: SCNGeometry
    let xAxisNode: SCNNode
    let yAxisNode: SCNNode
    let zAxisNode: SCNNode
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
    
    // MARK: - Init
    
    init(axisRadius: CGFloat,
         axisHeight: CGFloat,
         arrowBottomRadius: CGFloat,
         arrowHeight: CGFloat) {
        
        xAxis = SCNCylinder(radius: axisRadius, height: axisHeight)
        yAxis = SCNCylinder(radius: axisRadius, height: axisHeight)
        zAxis = SCNCylinder(radius: axisRadius, height: axisHeight)
        
        xAxisArrow = SCNCone(topRadius: 0, bottomRadius: arrowBottomRadius, height: arrowHeight)
        yAxisArrow = SCNCone(topRadius: 0, bottomRadius: arrowBottomRadius, height: arrowHeight)
        zAxisArrow = SCNCone(topRadius: 0, bottomRadius: arrowBottomRadius, height: arrowHeight)
        
        xAxisNode = SCNNode(geometry: xAxis)
        yAxisNode = SCNNode(geometry: yAxis)
        zAxisNode = SCNNode(geometry: zAxis)
        
        xArrowNode = SCNNode(geometry: xAxisArrow)
        yArrowNode = SCNNode(geometry: yAxisArrow)
        zArrowNode = SCNNode(geometry: zAxisArrow)
        
        originGeometry = SCNSphere(radius: axisRadius)
        
        planeXY = SCNPlane(width: 0.5, height: 0.5)
        planeXZ = SCNPlane(width: 0.5, height: 0.5)
        planeYZ = SCNPlane(width: 0.5, height: 0.5)
        
        planeXYNode = SCNNode(geometry: planeXY)
        planeXZNode = SCNNode(geometry: planeXZ)
        planeYZNode = SCNNode(geometry: planeYZ)
        
        super.init()
        
        setupAxis(axisHeight: axisHeight)
        
        
        planeXY.materials.first!.diffuse.contents = UIColor.red.withAlphaComponent(0.5)
        planeXYNode.position = SCNVector3(0.25, 0.25, 0)
        addChildNode(planeXYNode)
        
        planeXZ.materials.first!.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
        planeXZNode.eulerAngles = SCNVector3(0, Double.pi/2, 0)
        planeXZNode.position = SCNVector3(0, 0.25, 0.25)
        addChildNode(planeXZNode)
        
        planeYZ.materials.first!.diffuse.contents = UIColor.yellow.withAlphaComponent(0.5)
        planeYZNode.eulerAngles = SCNVector3(-Double.pi/2, 0, 0)
        planeYZNode.position = SCNVector3(0.25, 0, 0.25)
        addChildNode(planeYZNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupAxis(axisHeight: CGFloat) {
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
    
}
