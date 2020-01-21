//
//  PlotConnection.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/20/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import UIKit

/**
 An object to help the `PlotDelegate` pass along connection attributes for a connection.
 */
public struct PlotConnection {
    
    /// The radius of a connection.
    public var radius: CGFloat
    /// The color of a connection.
    public var color: UIColor
    
    /**
     Initializes a set of attributes that can be used for a connection.
     - parameters:
        - radius: The radius of a connection.
        - color: The color of a connection.
     */
    public init(radius: CGFloat = 0.03,
                color: UIColor = .orange) {
        self.radius = radius
        self.color = color
    }
    
}
