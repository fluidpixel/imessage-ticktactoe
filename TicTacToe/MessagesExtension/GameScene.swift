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
    
    
}
