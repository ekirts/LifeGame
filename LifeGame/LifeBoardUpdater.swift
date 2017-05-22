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
    
    var timer: Timer?
    
    // MARK: - Public Methods
    
    func updateCoordinates(model: LifeBoardModel) {
        coordinatesForUpdate.removeAll()
        
        model.coordinates.forEach { (coordinate) in
            coordinatesForUpdate.append(coordinate.value)
        }
    }
    
    func startUpdate() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(nextStep), userInfo: nil, repeats: true)
    }
    
    func stopUpdate() {
        timer?.invalidate()
    }
    
    @objc func nextStep() {
        defer {
            cellForRefresh?(coordinatesForUpdate)
            updateCoordinateForUpdate()
        }
        
        coordinatesForUpdate = coordinatesForUpdate.map { (coordinate) in
            var lifeCount = 0
            
            self.model?.nearCellForCoordinate(coordinate: coordinate).forEach({ (newCoordinate) in
                if newCoordinate.isLife {
                    lifeCount += 1
                }
            })
            
            if lifeCount < 2 || lifeCount > 3 {
                return Coordinate(x: coordinate.x, y: coordinate.y, isLife: false)
            } else if lifeCount == 2 || !coordinate.isLife {
                return Coordinate(x: coordinate.x, y: coordinate.y, isLife: false)
            } else {
                return Coordinate(x: coordinate.x, y: coordinate.y, isLife: true)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func updateCoordinateForUpdate() {
        coordinatesForUpdate = coordinatesForUpdate.filter { (coordinate) -> Bool in
            var isNeedUpdate = false
            self.model?.nearCellForCoordinate(coordinate: coordinate).forEach({ (newCoordinate) in
                if newCoordinate.isLife {
                    isNeedUpdate = true
                }
            })
            return isNeedUpdate
        }
    }
    
}
