//
//  BoardScene.swift
//  TicTacToe
//
//  Created by Lauren Brown on 11/07/2016.
//  Copyright © 2016 Fluid Pixel. All rights reserved.
//  Specific logic to tic tac toe

import Foundation
import SpriteKit

class BoardScene: GameScene {
    
    var board = [SKNode]() // nine nodes
    let backImage = SKSpriteNode(imageNamed: "grid")
    var selectedIndex: Int?
    weak var sender: MoveViewController?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let player1Moves = Game.history.grabPlayerMoves(playerID: 0)
        let player2Moves = Game.history.grabPlayerMoves(playerID: 1)
        
        
        for all in player1Moves {
            if let sprite = self.childNode(withName: "\(all)") {
                let action = SKAction.setTexture(SKTexture(imageNamed: "O"))
                sprite.run(action)
            }
        }
        
        for all in player2Moves {
            if let sprite = self.childNode(withName: "\(all)") {
                let action = SKAction.setTexture(SKTexture(imageNamed: "X"))
                sprite.run(action)
            }
        }
        if let sprite = self.childNode(withName: "LabelName") as? SKLabelNode {
            if Game.players.isPlayer1 {
                
                    let action = SKAction.run({
                        sprite.text = "Player 1 - Make Your Move!"
                    })
                    sprite.run(action)
                
            } else {
                let action = SKAction.run({
                    sprite.text = "Player 2 - Make Your Move!"
                })
                sprite.run(action)
                
            }
        }
        
    }

    
    override func didMove(to view: SKView) {
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let nodeNames = NodeHit(touches)
        
        //HANDLE GAME SPECIFIC LOGIC HERE
        for name in nodeNames {
            
            if name != "grid" && name != "LabelConfirm" {
            //TODO: handle texture change and logic
            //print("TOUCHED point \(self.children[i].name)" )
                if let sprite = self.childNode(withName: name) {
                    if Game.players.isPlayer1 {
                        let action = SKAction.setTexture(SKTexture(imageNamed: "O"))
                            sprite.run(action)
                                
                                if selectedIndex != nil {
                                    Game.history.removeMoves(player: "0", moves: selectedIndex!)
                                     Game.winCondition.removeResult(previousValue: 1, index: selectedIndex!)
                                    if let spriteToRemove = self.childNode(withName: "\(selectedIndex!)") {
                                        let action = SKAction.setTexture(SKTexture(imageNamed: "blank"))
                                        spriteToRemove.run(action)
                                    }
                                }
                                
                                Game.history.addMoves(player: "0", moves: Int(name)!)
                                Game.winCondition.addResult(value: 1, index: Int(name)!)
                                
                            } else {
                                let action = SKAction.setTexture(SKTexture(imageNamed: "X"))
                                sprite.run(action)
                                
                                if selectedIndex != nil {
                                    Game.history.removeMoves(player: "1", moves: selectedIndex!)
                                    Game.winCondition.removeResult(previousValue: -1, index: selectedIndex!)
                                    
                                    if let spriteToRemove = self.childNode(withName: "\(selectedIndex!)") {
                                        let action = SKAction.setTexture(SKTexture(imageNamed: "blank"))
                                        spriteToRemove.run(action)
                                    }
                                }
                                Game.history.addMoves(player: "1", moves: Int(name)!)
                                Game.winCondition.addResult(value: -1, index: Int(name)!)
                                
                            }
                            selectedIndex = Int(name)!
                            
                        }
                        }
                        if name == "LabelConfirm" {
                            //send scenetree over
                            var nodeTree = self.children
                            var nodesToRemove = [SKNode]()
                            enumerateChildNodes(withName: "Label*", using: { (node, _) in
                                nodesToRemove.append(node)
                            })
                            
                            for all in nodesToRemove {
                                nodeTree.removeObject(object: all)
                            }
                            Game.sceneTreeToRender = nodeTree as? [SKSpriteNode]
                            sender?.ConfirmPressed()
                        }
                    }
    }
}
    
    


extension SKScene {
    
    class func unarchiveFromFile(file: String) -> SKScene? {
        if let path = Bundle.main().pathForResource(file, ofType: "sks") {
            do {
            let sceneData = try NSData(contentsOfFile: path, options: .dataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWith: sceneData as Data)
            
            archiver.setClass(self.classForKeyedArchiver(), forClassName: "SKScene")
            
            let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! SKScene
            archiver.finishDecoding()
            
            return scene
            } catch {
                print("ERROR")
                return nil
            }
        } else {
            return nil
        }
    }
    
}
