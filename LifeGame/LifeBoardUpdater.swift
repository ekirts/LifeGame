//
//  LifeBoardUpdater.swift
//  LifeGame
//
//  Created by Alex Uv on 22.05.17.
//  Copyright © 2017 Alex Uv. All rights reserved.
//

import Foundation

// MARK: - LifeBoardUpdater

class LifeBoardUpdater {
    
    // MARK: - Public Properties
    
    var cellForRefresh: (([Coordinate]) -> Void)?
    
    var coordinatesForUpdate: [Coordinate] = []
    var model: LifeBoardModel? {
        didSet {
            if let model = model {
                updateCoordinates(model: model)
            }
        }
    }
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    private let timeUpdate = 0.3
    
    private let firstLife = [Coordinate(x: 0, y: 0, isLife: true),
                             Coordinate(x: 0, y: 1, isLife: true),
                             Coordinate(x: 0, y: 2, isLife: true)]
    
    private let secondLife = [Coordinate(x: 3, y: 2, isLife: true),
                              Coordinate(x: 5, y: 2, isLife: true),
                              Coordinate(x: 6, y: 3, isLife: true),
                              Coordinate(x: 6, y: 4, isLife: true),
                              Coordinate(x: 6, y: 5, isLife: true),
                              Coordinate(x: 6, y: 6, isLife: true),
                              Coordinate(x: 6, y: 7, isLife: true),
                              Coordinate(x: 5, y: 7, isLife: true),
                              Coordinate(x: 4, y: 7, isLife: true),
                              Coordinate(x: 3, y: 6, isLife: true),
                              Coordinate(x: 2, y: 4, isLife: true)]
    
    private let thirdLife = [Coordinate(x: 3, y: 0, isLife: true),
                             Coordinate(x: 3, y: 1, isLife: true),
                             Coordinate(x: 3, y: 2, isLife: true),
                             Coordinate(x: 2, y: 2, isLife: true),
                             Coordinate(x: 1, y: 1, isLife: true)]
    
    private let fourLife  = [Coordinate(x: 2, y: 0, isLife: true),
                             Coordinate(x: 4, y: 1, isLife: true),
                             Coordinate(x: 4, y: 2, isLife: true),
                             Coordinate(x: 1, y: 3, isLife: true),
                             Coordinate(x: 0, y: 2, isLife: true),
                             Coordinate(x: 0, y: 1, isLife: true)]
    
    private let fiveLife  = [Coordinate(x: 3, y: 1, isLife: true),
                             Coordinate(x: 3, y: 2, isLife: true),
                             Coordinate(x: 4, y: 3, isLife: true),
                             Coordinate(x: 2, y: 3, isLife: true),
                             Coordinate(x: 2, y: 4, isLife: true),
                             Coordinate(x: 1, y: 2, isLife: true)]
    
    // MARK: - Public Methods
    
    func updateCoordinates(model: LifeBoardModel) {
        coordinatesForUpdate.removeAll()
        
        model.coordinates.forEach { (coordinate) in
            coordinatesForUpdate.append(coordinate.value)
        }
    }
    
    func startUpdate() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeUpdate), target: self, selector: #selector(nextStep), userInfo: nil, repeats: true)
    }
    
    func stopUpdate() {
        timer?.invalidate()
    }
    
    @objc func nextStep() {
        defer {
            updateCoordinateForUpdate()
            cellForRefresh?(coordinatesForUpdate)
        }
        
        let temporaryCoordibatesBoard = model?.coordinates
        
        coordinatesForUpdate = coordinatesForUpdate.flatMap { (coordinate) -> Coordinate? in
            var lifeCount = 0
            
            self.model?.nearCellForCoordinate(coordinate: coordinate, coordinatesBoard: temporaryCoordibatesBoard!).forEach({ (newCoordinate) in
                if newCoordinate.isLife {
                    lifeCount += 1
                }
            })
            
            if coordinate.isLife {
                lifeCount -= 1
            }
            
            if (lifeCount < 2 || lifeCount > 3) && coordinate.isLife {
                let updateCoordinate = Coordinate(x: coordinate.x, y: coordinate.y, isLife: false)
                model?.coordinates["\(coordinate.x)-\(coordinate.y)"] = updateCoordinate
                return updateCoordinate
            } else if lifeCount == 2 && !coordinate.isLife {
                let updateCoordinate = Coordinate(x: coordinate.x, y: coordinate.y, isLife: false)
                model?.coordinates["\(coordinate.x)-\(coordinate.y)"] = updateCoordinate
                return updateCoordinate
            } else if !coordinate.isLife && lifeCount == 3 {
                let updateCoordinate = Coordinate(x: coordinate.x, y: coordinate.y, isLife: true)
                model?.coordinates["\(coordinate.x)-\(coordinate.y)"] = updateCoordinate
                return updateCoordinate
            } else if lifeCount == 2 && coordinate.isLife {
                let updateCoordinate = Coordinate(x: coordinate.x, y: coordinate.y, isLife: true)
                model?.coordinates["\(coordinate.x)-\(coordinate.y)"] = updateCoordinate
                return updateCoordinate
            } else {
                return nil
            }
        }
    }
    
    func addRandomLife() {
        guard let xCount = model?.xCount, let yCount = model?.yCount else {
            return
        }
        
        let countLife = arc4random() % 25
        var coordinate = model?.coordinates["\(arc4random() % UInt32(xCount))-\(arc4random() % UInt32(yCount))"]
        coordinate?.isLife = true
        
        var randomCoordinate = coordinate
        for _ in 0...countLife {
            if let coordinate = randomCoordinate {
                model?.nearCellForCoordinate(coordinate: coordinate, coordinatesBoard: (model?.coordinates)!).forEach({ (newCoordinate) in
                    if arc4random() % 8 == 1 {
                        model?.coordinates["\(newCoordinate.x)-\(newCoordinate.y)"]?.isLife = true
                        coordinatesForUpdate.append((model?.coordinates["\(newCoordinate.x)-\(newCoordinate.y)"])!)
                        randomCoordinate = model?.coordinates["\(newCoordinate.x)-\(newCoordinate.y)"]
                    }
                })
            }
        }
        
        updateCoordinateForUpdate()
        cellForRefresh?(coordinatesForUpdate)
    }
    
    func addLife() {
        randomOriginAddLife(life: firstLife)
        randomOriginAddLife(life: secondLife)
        randomOriginAddLife(life: thirdLife)
        randomOriginAddLife(life: fourLife)
        randomOriginAddLife(life: fiveLife)
        
        updateCoordinateForUpdate()
        cellForRefresh?(coordinatesForUpdate)
    }
    
    // MARK: - Private Methods
    
    private func randomOriginAddLife(life: [Coordinate]) {
        let randomX = arc4random() % UInt32(model?.xCount ?? 0)
        let randomY = arc4random() % UInt32(model?.yCount ?? 0)
        
        life.forEach { (coordinate) in
            let x = coordinate.x + Int(randomX)
            let y = coordinate.y + Int(randomY)
            let coord = model?.coordinateInBoard(x: x, y: y, coordinatesBoard: (model?.coordinates)!)
            model!.coordinates["\(coord!.x)-\(coord!.y)"]?.isLife = true
            coordinatesForUpdate.append((model?.coordinates["\(coord!.x)-\(coord!.y)"])!)
        }
    }
    
    private func updateCoordinateForUpdate() {
        var temporarySet = Set<Coordinate>()
        
        
        coordinatesForUpdate.forEach { (coordinate) in
            if coordinate.isLife {
                self.model?.nearCellForCoordinate(coordinate: coordinate, coordinatesBoard: (model?.coordinates)!).forEach({ (newCoordinate) in
                    temporarySet.insert(newCoordinate)
                    return
                })
            }
        }
        coordinatesForUpdate.removeAll()
        coordinatesForUpdate.append(contentsOf: temporarySet)
    }
    
}
