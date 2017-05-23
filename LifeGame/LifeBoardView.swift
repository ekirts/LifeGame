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
    private var width = 0
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, model: LifeBoardModel) {
        self.model = model
        
        super.init(frame: frame)
        
        createDesk(model: model)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func clearAll() {
        cells.forEach { (cell) in
            cell.value.view.removeFromSuperview()
        }
        cells.removeAll()
    }
    
    func updateDesk(model: [Coordinate]) {
        clearAll()
        
        model.forEach { (coordinate) in
            if coordinate.isLife {
                let frame = CGRect(x: coordinate.x * width, y: coordinate.y * width, width: width, height: width)
                let cell = UIView(frame: frame)
                cell.backgroundColor = UIColor.black
                
                cells["\(coordinate.x)-\(coordinate.y)"] = Cell(coordinate: coordinate, view: cell)
                
                addSubview(cell)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func createDesk(model: LifeBoardModel) {
        width = {
            if (Int(bounds.width) / model.xCount) > (Int(bounds.height) / model.yCount) {
                return Int(bounds.height) / model.yCount
            } else {
                return Int(bounds.width) / model.xCount
            }
        }()
        
        model.coordinates.forEach { (coordinate) in
            if coordinate.value.isLife {
                let frame = CGRect(x: coordinate.value.x * width, y: coordinate.value.y * width, width: width, height: width)
                let cell = UIView(frame: frame)
                cell.backgroundColor = UIColor.black
                
                cells["\(coordinate.value.x)-\(coordinate.value.y)"] = Cell(coordinate: coordinate.value, view: cell)
                
                addSubview(cell)
            }
        }
    }

}
