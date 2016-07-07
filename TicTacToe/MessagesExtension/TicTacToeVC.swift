//
//  TicTacToeVC.swift
//  TicTacToe
//
//  Created by Lauren Brown on 22/06/2016.
//  Copyright © 2016 Fluid Pixel. All rights reserved.

/* ABSTRACT:
    Shows the current board from the game and has a button to allow the user to make a move
 */
//

import Foundation
import UIKit

class TicTacToeVC: UIViewController{
    
    static let storyBoardID = "TTTController"
    
    let width = 50
    let height = 50
    
    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var ContinueButton: UIButton!
    
    
    var delegate: SendDelegate?
    
    var indexForChange : Int?
    
    
    required init?(coder aDecoder: NSCoder) {
        //show the current board state
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Game.history.load()
        if Game.history.grabPlayerMoves(playerID: 0).count <= 0 {
            ContinueButton.isHidden = true
        }
        
    }
    
    @IBAction func NewGamePressed(_ sender: UIButton) {
        
        Game.history.save(clearHistory: true)
        
        Game.players.isPlayer1 = true
        Game.initial = true
        
        delegate?.SelectMove(self)
    }
    
    @IBAction func ContinuePressed(_ sender: UIButton) {
       
            Game.players.isPlayer1 = Game.history.savedLocalPlayer
            Game.initial = false
            
            delegate?.SelectMove(self)
       
        
        
    }
    
    
}

