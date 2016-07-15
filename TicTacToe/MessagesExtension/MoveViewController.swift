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
    
    @IBOutlet weak var Board: UIImageView!
    
    @IBOutlet weak var Label: UILabel!
    
    @IBOutlet weak var ConfirmButton: UIButton!
    
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
//        gridSprite = BoardScene(size: self.view.bounds.size)
//        
//        gridSprite?.scaleMode = .aspectFill
        if let scene = SKScene(fileNamed: "TTTScene") as? BoardScene {
            scene.scaleMode = .aspectFill
            scene.sender = self
           // scene.anchorPoint = CGPoint(x: scene.anchorPoint.x, y: 0)
            skView.presentScene(scene)
        }
        
        
        //Game.history.load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
