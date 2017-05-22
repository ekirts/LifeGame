//
//  LifeBoardView.swift
//  LifeGame
//
//  Created by Alex Uv on 22.05.17.
//  Copyright © 2017 Alex Uv. All rights reserved.
//

import UIKit

// MARK: - ViewController

class LifeBoardView: UIView {
    
    struct Cell {
        var coordinate: Coordinate
        let view: UIView
    }
    
    // MARK: - Private Properties
    
    private let model: LifeBoardModel
    private var cells: [String: Cell] = [:]
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, model: LifeBoardModel) {
        self.model = model
        
        super.init(frame: frame)
        
        createDesk()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func clearAll() {
        cells.forEach { (cell) in
            cell.value.view.backgroundColor = UIColor.clear
        }
    }
    
    func updateCellFor(coordinates: [Coordinate]) {
        coordinates.forEach { (coordinate) in
            cells["\(coordinate.x)\(coordinate.y)"]?.coordinate.isLife = coordinate.isLife
            cells["\(coordinate.x)\(coordinate.y)"]?.view.backgroundColor = coordinate.isLife ? UIColor.black : UIColor.white
        }
    }
    
    // MARK: - Private Methods
    
    private func createDesk() {
        let size: Int = {
            if (Int(bounds.width) / model.xCount) > (Int(bounds.height) / model.yCount) {
                return Int(bounds.height) / model.yCount
            } else {
                return Int(bounds.width) / model.xCount
            }
        }()
        
        model.coordinates.forEach { (coordinate) in
            let frame = CGRect(x: coordinate.value.x * size, y: coordinate.value.y * size, width: size, height: size)
            let cell = UIView(frame: frame)
            cell.backgroundColor = coordinate.value.isLife ? UIColor.black : UIColor.white
            cells["\(coordinate.value.x)\(coordinate.value.y)"] = Cell(coordinate: coordinate.value, view: cell)
                
            addSubview(cell)
        }
    }

}
