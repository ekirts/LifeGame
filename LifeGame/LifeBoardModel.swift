//
//  LifeBoardModel.swift
//  LifeGame
//
//  Created by Alex Uv on 22.05.17.
//  Copyright © 2017 Alex Uv. All rights reserved.
//

import Foundation

// MARK: - Coordinate

struct Coordinate {
    let x: Int
    let y: Int
    var isLife: Bool
}

// MARK: - LifeBoardModel

class LifeBoardModel {
    
    // MARK: - Public Properties
    
    let coordinates: [String: Coordinate]
    let xCount: Int
    let yCount: Int
    
    // MARK: - Lifecycle
    
    init(x: Int, y: Int) {
        self.xCount = x
        self.yCount = y
        
        var coordinate: [String: Coordinate] = [:]
        for xCoordinate in 0...x {
            for yCoordinate in 0...y {
                coordinate["\(xCoordinate)\(yCoordinate)"] = Coordinate(x: xCoordinate, y: yCoordinate, isLife: (arc4random() % 12) == 1)
            }
        }
        self.coordinates = coordinate
    }
    
    // MARK: - Public Methods
    
    func nearCellForCoordinate(coordinate: Coordinate) -> [Coordinate] {
        var coordinates: [Coordinate] = []
        coordinates.append(coordinateInBoard(x: coordinate.x - 1,   y: coordinate.y - 1))
        coordinates.append(coordinateInBoard(x: coordinate.x,       y: coordinate.y - 1))
        coordinates.append(coordinateInBoard(x: coordinate.x + 1,   y: coordinate.y - 1))
        coordinates.append(coordinateInBoard(x: coordinate.x - 1,   y: coordinate.y))
        coordinates.append(coordinateInBoard(x: coordinate.x - 1,   y: coordinate.y + 1))
        coordinates.append(coordinateInBoard(x: coordinate.x + 1,   y: coordinate.y))
        coordinates.append(coordinateInBoard(x: coordinate.x,       y: coordinate.y + 1))
        coordinates.append(coordinateInBoard(x: coordinate.x + 1,   y: coordinate.y + 1))
        
        return coordinates
    }
    
    func coordinateInBoard(x: Int, y: Int) -> Coordinate {
        var coordinate = (x, y)
        if x < 0 {
            coordinate.0 = xCount
        } else if x > xCount {
            coordinate.0 = 0
        }
        if y < 0 {
            coordinate.1 = yCount
        } else if y > yCount {
            coordinate.1 = 0
        }
        
        return Coordinate(x: coordinate.0, y: coordinate.1, isLife: coordinates["\(coordinate.0)\(coordinate.1)"]?.isLife ?? false)
    }
    
}
