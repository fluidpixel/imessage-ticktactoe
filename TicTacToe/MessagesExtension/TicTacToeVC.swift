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
    
    @IBOutlet weak var ImageGrid: UIImageView!
    @IBOutlet weak var AddMoveButton: UIButton!
    @IBOutlet weak var NewGameButton: UIButton!
    @IBOutlet weak var InteractiveGrid: UICollectionView!
    
    var delegate: SendDelegate?
    
    var indexForChange : Int?
    
    
    required init?(coder aDecoder: NSCoder) {
        //show the current board state
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func NewGamePressed(_ sender: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: MoveViewController.storyboardID) as? MoveViewController else {
            fatalError("Unable to instantiate view controller")
        }
        Game.history.save(clearHistory: true)
        controller.delegate = delegate
        controller.player = "0"
        controller.initialMove = true
        
        present(controller, animated: true, completion: nil)
    }
    
}

