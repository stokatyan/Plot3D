//
//  PlotDataSource.swift
//  Plot3D
//
//  Created by Shant Tokatyan on 1/7/20.
//  Copyright © 2020 Stokaty. All rights reserved.
//

import Foundation

public protocol PlotDataSource: class {
    func numberOfPoints() -> Int
}
