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
    
//    override init(size: CGSize) {
//        super.init(size: size)
//        
//       
//        
//        
//        
////        let width = backImage.size.width
////        let height = backImage.size.height
//        
////        backImage.position = CGPoint(x: 100, y: 100)
////        backImage.anchorPoint = CGPoint()
////        addChild(backImage)
////        
////        for i in 0 ..< 9 {
////            
////            let y = (height / 3 ) * CGFloat(Int(CGFloat(i) / 3)) + backImage.position.y
////            let x =  (width / 3) * (CGFloat(i).truncatingRemainder(dividingBy: 3)) + backImage.position.x
////            var sprite = SKSpriteNode(imageNamed: "O")
////            sprite.position = CGPoint(x: x, y: y)
////            sprite.anchorPoint = CGPoint()
////            sprite.size = CGSize(width: width / 3, height: height / 3)
////            board.append(sprite)
////            addChild(sprite)
////        }
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        board.append(contentsOf: self.children)
    }

    
    override func didMove(to view: SKView) {
    
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for any: AnyObject in touches {
            if let touch = any as? UITouch {
                
                let location = touch.location(in: self.view)
                
                for node in board {
                    
                    if node.contains(location) {
                        //TODO: handle texture change and logic
                        print("TOUCH")
                        
                    }
                }
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
