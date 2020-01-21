//
//  PlotText.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/19/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import SceneKit

/**
 A conveniance object so that nodes with text can be created without having to acces  `SCNText`.
 In addition, a  `PlotText` object generates a new node with centered text so that attributes of geometries can be reused or slightly modified.
 */
public struct PlotText {
    
    /// The text to use for the created node's geometry.
    var text: String
    /// The color to use for the created node's geometry.
    var textColor: UIColor
    /// The name of the font for the text.
    var fontName: String
    /// The size of the font for the text.
    var fontSize: CGFloat
    /// A number that determines the accuracy or smoothness of the text geometry, the closer to 0 the smoother the geometry.
    var flatness: CGFloat
    /**
     An amount to offset the text node by.
     The text in a 3d plot is only ever offset in 1 direction, and the direction depends on the axis the text is layed out on.
     As a result, the offset is directionless, and whatever is charge of plotting the text will determine the direction of the offset.
     */
    var offset: CGFloat
    
    /// Creates and returns a new node with a centered `SCNText` geometry that is modified with the instances current properties.
    var node: SCNNode {
        let textGeometry = SCNText(string: text, extrusionDepth: 0)
        textGeometry.flatness = flatness
        textGeometry.font = UIFont(name: fontName, size: fontSize)
        textGeometry.materials.first!.diffuse.contents = textColor
        
        let textNode = SCNNode(geometry: textGeometry)
        
        let (min, max) = (textGeometry.boundingBox.min, textGeometry.boundingBox.max)
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        return textNode
    }
    
    /// Creates and returns a new node with a right-aligned `SCNText` geometry that is modified with the instances current properties.
    var nodeRightAligned: SCNNode {
        let textGeometry = SCNText(string: text, extrusionDepth: 0)
        textGeometry.flatness = flatness
        textGeometry.font = UIFont(name: fontName, size: fontSize)
        textGeometry.materials.first!.diffuse.contents = textColor
        
        let textNode = SCNNode(geometry: textGeometry)
        
        let (min, max) = (textGeometry.boundingBox.min, textGeometry.boundingBox.max)
        let dx = min.x + 1 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        return textNode
    }

    /**
     Initializes a `PlotText` object which can be used to generate nodes with centered text.
     - parameters:
        - text: The text to use for the created node's geometry.
        - textColor: The color to use for the created node's geometry.
        - fontName: The name of the font for the text.
        - fontSize: The size of the font for the text.
        - flatness: A number that determines the accuracy or smoothness of the text geometry, the closer to 0 the smoother the geometry.
        - offset: An amount to offset the text node by.  The offset is directionless, and whatever is charge of plotting the text will determine the direction of the offset.
    */
    public init(text: String,
                textColor: UIColor = .white,
                fontName: String = "AppleSDGothicNeo-UltraLight",
                fontSize: CGFloat = 0.5,
                flatness: CGFloat = 0.001,
                offset: CGFloat = 0.6) {
        self.text = text
        self.textColor = textColor
        self.fontName = fontName
        self.fontSize = fontSize
        self.flatness = flatness
        self.offset = offset
    }
    
    
}
