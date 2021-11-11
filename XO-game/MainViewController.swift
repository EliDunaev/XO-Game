//
//  MainViewvController.swift
//  XO-game
//
//  Created by Илья Дунаев on 10.11.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameViewController = segue.destination as? GameViewController else { return }
        
        if segue.identifier == "2Players" {
            gameViewController.gameSettings = .AI
        } else if segue.identifier == "AI" {
            gameViewController.gameSettings = .playerVsPlayer
        }
    }

}
