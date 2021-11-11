//
//  PlayerVsPlayerState.swift
//  XO-game
//
//  Created by Илья Дунаев on 10.11.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayerVsPlayerState: GameState {
    var isCompleted: Bool = false
    
    let player: Player
    private unowned let gameViewController: GameViewController
    private let gameboard: Gameboard
    private let gameboardView: GameboardView
    private let markPrototype: MarkView
    private var numberOfMoves: Int = 5
    
    init(player: Player,
         markPrototype: MarkView,
         gameViewController: GameViewController,
         gameboard: Gameboard,
         gameboardView: GameboardView) {
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
        appendMove(player: self.player, position: position, gameboard: self.gameboard, gameboardView: self.gameboardView)
        
        self.gameboard.setPlayer(self.player, at: position)
        self.gameboardView.placeMarkView(markPrototype.copy(), at: position)
        
        self.numberOfMoves -= 1
        
        if self.numberOfMoves == 0 {
            self.isCompleted = true
        }
    }
}
