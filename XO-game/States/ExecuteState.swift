//
//  ExecuteState.swift
//  XO-game
//
//  Created by Илья Дунаев on 10.11.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class ExecuteState: GameState {
    var isCompleted: Bool = false
    
    private unowned let gameViewController: GameViewController
    
    init(gameViewController: GameViewController) {
        self.gameViewController = gameViewController
    }
    
    func begin() {
        self.gameViewController.firstPlayerTurnLabel.isHidden = true
        self.gameViewController.secondPlayerTurnLabel.isHidden = true
        
        self.gameViewController.winnerLabel.isHidden = true
        Invoker.shared.execute()
        self.isCompleted = true
    }
    
    func addMark(at position: GameboardPosition) { }
}
