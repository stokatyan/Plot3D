//
//  AxisNode.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 12/19/19.
//  Copyright © 2019 Stokaty. All rights reserved.
//

import SceneKit

class AxisNode: SCNNode {
    
    let xAxis: SCNGeometry
    let yAxis: SCNGeometry
    let zAxis: SCNGeometry
    
    let xAxisArrow: SCNGeometry
    let yAxisArrow: SCNGeometry
    let zAxisArrow: SCNGeometry
    
    let xAxisNode: SCNNode
    let yAxisNode: SCNNode
    let zAxisNode: SCNNode
    
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
        
        super.init()
        
        xAxisNode.position = SCNVector3(axisHeight/2, 0, 0)
        xAxisNode.eulerAngles = SCNVector3(0, 0, -Double.pi/2)
        let arrowNodeX = SCNNode(geometry: xAxisArrow)
        arrowNodeX.position = SCNVector3(0, axisHeight/2, 0)
        xAxisNode.addChildNode(arrowNodeX)
        addChildNode(xAxisNode)

        yAxisNode.position = SCNVector3(0, axisHeight/2, 0)
        let arrowNodeY = SCNNode(geometry: yAxisArrow)
        arrowNodeY.position = SCNVector3(0, axisHeight/2, 0)
        yAxisNode.addChildNode(arrowNodeY)
        addChildNode(yAxisNode)
        
        zAxisNode.position = SCNVector3(0, 0, axisHeight/2)
        zAxisNode.eulerAngles = SCNVector3(Double.pi/2, 0, 0)
        let arrowNodeZ = SCNNode(geometry: zAxisArrow)
        arrowNodeZ.position = SCNVector3(0, axisHeight/2, 0)
        zAxisNode.addChildNode(arrowNodeZ)
        addChildNode(zAxisNode)

        
        let origin = SCNSphere(radius: axisRadius)
        origin.materials.first!.diffuse.contents = UIColor.white
        let originNode = SCNNode(geometry: origin)
        originNode.position = SCNVector3(0, 0, 0)
        addChildNode(originNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
