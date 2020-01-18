//
//  PlotDataSource.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/7/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import Foundation

/**
 A protocol for getting the data source of a plot.
 */
public protocol PlotDataSource: class {
    /**
     - returns: The number of points to plot.
     */
    func numberOfPoints() -> Int
}
