//
//  ViewController.swift
//  LifeGame
//
//  Created by Alex Uv on 22.05.17.
//  Copyright © 2017 Alex Uv. All rights reserved.
//

import UIKit

// MARK: - ViewController

class ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var lifeBoardView: UIView!
    
    // MARK: - Private Properties
    
    private let width = 100
    private let heigh = 100
    
    private var model: LifeBoardModel!
    private var boardView: LifeBoardView!
    private var updater: LifeBoardUpdater!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBoard()
    }
    
    // MARK: - Private Methods
    
    private func createBoard() {
        model = LifeBoardModel(x: width, y: heigh)
        boardView = LifeBoardView(frame: lifeBoardView.frame, model: model)
        view.addSubview(boardView)
        updater = LifeBoardUpdater()
        updater.model = model
        updater.cellForRefresh = { [weak self] (coordinates) in
            self?.boardUpdate(coordinates: coordinates)
        }
    }
    
    func boardUpdate(coordinates: [Coordinate]) {
        boardView.updateDesk(model: coordinates)
    }

    // MARK: - Actions

    @IBAction private func nuclearAction(_ sender: Any) {
        model = LifeBoardModel(x: width, y: heigh)
        updater.model = model
        boardView.clearAll()
    }
    
    @IBAction private func birdAction(_ sender: Any) {
        updater.addRandomLife()
    }
    
    @IBAction private func stopAction(_ sender: Any) {
        updater.stopUpdate()
    }
    
    @IBAction private func nextStepAction(_ sender: Any) {
        updater.stopUpdate()
        updater.nextStep()
    }
    
    @IBAction private func playAction(_ sender: Any) {
        updater.startUpdate()
    }
    
    @IBAction private func addlife(_ sender: Any) {
        updater.addLife()
    }
    
}

