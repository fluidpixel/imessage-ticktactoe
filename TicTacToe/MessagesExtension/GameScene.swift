//
//  GameScene.swift
//  TicTacToe
//
//  Created by Lauren Brown on 13/07/2016.
//  Copyright © 2016 Fluid Pixel. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.white()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //GENERIC LOGIC HERE
        
        
        
    }
    
    func NodeHit(_ touches: Set<UITouch>) -> [String] {
        
        var nodeNames = [String]()
        
        for any: AnyObject in touches {
            if let touch = any as? UITouch {
                
                let location = touch.location(in: self)
                
                for i in 0..<self.children.count {
                    
                    if self.children[i].contains(location) {
                        nodeNames.append(self.children[i].name!)
                        
                    }
                }
            }
        }
        return nodeNames
    }
}
