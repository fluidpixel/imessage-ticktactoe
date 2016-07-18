//
//  ViewController.swift
//  TicTacToe
//
//  Created by Lauren Brown on 24/06/2016.
//  Copyright © 2016 Fluid Pixel. All rights reserved.
//

import UIKit
import SpriteKit
import SceneKit

class MoveViewController: UIViewController{
    
    static let storyboardID = "Move"
    var gridValues: TTTBoard?
    var initialMove = false
    
    weak var delegate: SendDelegate?
    var player: String?
    var player1Results: [Int]?
    var player2Results: [Int]?
    
    var selectedIndex: IndexPath?
    var gridSprite: BoardScene?

    @IBOutlet weak var skView: SKView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Game.initial {
            
            initialMove = true
            player = "0"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        skView.showsFPS = true

        if let scene = SKScene(fileNamed: "TTTScene") as? BoardScene {
            scene.scaleMode = .aspectFill
            scene.sender = self
           
            skView.presentScene(scene)
        }
        Game.history.load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ConfirmPressed() {
        
        if initialMove {
            Game.initial = false
            Game.players.isPlayer1 = true
            delegate?.TTTViewControllerNewGame(self)
        } else {
            delegate?.TTTViewControllerNextMove(self)
        }
        
    }
    
}

protocol SendDelegate: class {
    func TTTViewControllerNewGame(_ controller: MoveViewController)
    func TTTViewControllerNextMove(_ controller: MoveViewController)
    func SelectMove(_ controller: TicTacToeVC)
}

class TTTCell : UICollectionViewCell {
    
    @IBOutlet weak var images: UIImageView!
    
    static let reuseIdentifier = "cell"
}
