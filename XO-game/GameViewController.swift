//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    private lazy var referee = Referee(gameboard: self.gameboard)
    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }
    
    var gameSettings: GameSettings = .playerVsPlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.goToFirstState()
        
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.currentState.addMark(at: position)
            
            if self.currentState.isCompleted {
                self.goToNextState()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        self.gameboardView.clear()
        self.gameboard.clear()
        
        recordEvent(.restartGame)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Game state
    
    private func goToFirstState() {
        let player = Player.first
        
        switch self.gameSettings {
        case .AI:
            self.currentState = PlayerInputState(
                player: player,
                markPrototype: player.markViewPrototype,
                gameViewController: self,
                gameboard: self.gameboard,
                gameboardView: self.gameboardView
            )
        case .playerVsPlayer:
            self.currentState = PlayerVsPlayerState(
                player: player,
                markPrototype: player.markViewPrototype,
                gameViewController: self,
                gameboard: self.gameboard,
                gameboardView: self.gameboardView
            )
        }
    }
    
    private func goToNextState() {
        
        switch self.gameSettings {
        case .AI:
            if let winner = self.referee.determineWinner() {
                self.currentState = WinnerState(winnerPlayer: winner, gameViewController: self)
                return
            }
            
            if self.currentState is PlayerInputState {
                self.currentState = ArtificiaIntlnputState(
                    gameViewController: self,
                    gameboard: self.gameboard,
                    gameboardView: self.gameboardView
                )
                self.goToNextState()
            } else if let computerInputState = self.currentState as? ArtificiaIntlnputState {
                let nextPlayer = computerInputState.player.next
                self.currentState = PlayerInputState(
                    player: nextPlayer,
                    markPrototype: nextPlayer.markViewPrototype,
                    gameViewController: self,
                    gameboard: self.gameboard,
                    gameboardView: self.gameboardView
                )
            }
        case .playerVsPlayer:
            if let playerInputState = self.currentState as? PlayerVsPlayerState {
                self.gameboardView.clear()
                self.gameboard.clear()
                
                let nextPlayer = playerInputState.player.next
                if nextPlayer != .first {
                    self.currentState = PlayerVsPlayerState(
                        player: nextPlayer,
                        markPrototype: nextPlayer.markViewPrototype,
                        gameViewController: self,
                        gameboard: self.gameboard,
                        gameboardView: self.gameboardView
                    )
                } else {
                    self.currentState = ExecuteState(gameViewController: self)
                }
            }
            
            if self.currentState is ExecuteState, let winner = self.referee.determineWinner() {
                self.currentState = WinnerState(winnerPlayer: winner, gameViewController: self)
                return
            }
        }
    }
}

