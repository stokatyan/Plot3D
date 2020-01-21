//
//  PlotConnection.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/20/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import UIKit

public struct PlotConnection {
    
    public var radius: CGFloat
    public var color: UIColor
    
    public init(radius: CGFloat = 0.03,
                color: UIColor = .orange) {
        self.radius = radius
        self.color = color
    }
    
}
