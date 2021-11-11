//
//  PlayerInputState.swift
//  XO-game
//
//  Created by v.prusakov on 11/4/21.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayerInputState: GameState {
        
        var isCompleted: Bool = false
        
        let player: Player
        private unowned let gameViewController: GameViewController
        private let gameboard: Gameboard
        private let gameboardView: GameboardView
        private let markPrototype: MarkView
        
        init(player: Player, markPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
            self.player = player
            self.markPrototype = markPrototype
            self.gameboardView = gameboardView
            self.gameboard = gameboard
            self.gameViewController = gameViewController
        }
        
        func begin() {
            let isFirstPlayer = self.player == .first
            self.gameViewController.firstPlayerTurnLabel.isHidden = !isFirstPlayer
            self.gameViewController.secondPlayerTurnLabel.isHidden = isFirstPlayer
            
            self.gameViewController.winnerLabel.isHidden = true
        }
        
        func addMark(at position: GameboardPosition) {
            guard self.gameboardView.canPlaceMarkView(at: position) else { return }
            
            recordEvent(.playerInput(player: self.player, position: position))
            
            self.gameboard.setPlayer(self.player, at: position)
            self.gameboardView.placeMarkView(markPrototype.copy(), at: position)
            
            self.isCompleted = true
        }
    }
