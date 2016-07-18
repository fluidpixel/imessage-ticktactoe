//
//  TTTBoard.swift
//  TicTacToe
//
//  Created by Lauren Brown on 22/06/2016.
//  Copyright © 2016 Fluid Pixel. All rights reserved.

/*  object to store the representation of the TTT board, and maintain the game state
 */
//

import Foundation
import UIKit
import Messages
import SpriteKit

class TTTBoard {
    //example grid for testing has been added
    var grid : [TTTButton] = [TTTButton(loc_X_O: -1), TTTButton(loc_X_O: 0), TTTButton(loc_X_O: 0), TTTButton(loc_X_O: 1), TTTButton(loc_X_O: -1), TTTButton(loc_X_O: 1), TTTButton(loc_X_O: 1), TTTButton(loc_X_O: -1), TTTButton(loc_X_O: 0)]
    let background : UIImage = UIImage(named: "grid")!
    
    func setUpBoard(items: [URLQueryItem]) {
        
        var p1 = [Int]()
        var p2 = [Int]()
        
        for (i, queryItem) in items.enumerated() {
            guard let value = queryItem.value else { continue }
            if queryItem.name == "Value" {
            grid[i].setImage(X_O: Int(value)!)
                if Int(value)! == 1 {
                    p1.append(i)
                }else if Int(value)! == -1 {
                    p2.append(i)
                }
            
            } else if queryItem.name == "Player" {
                let retValue = value.lowercased() == "true"
                Game.players.isPlayer1 = !retValue
            }
        }
        Game.history.save(player1: p1, player2: p2, isLocalPlayer1: Game.players.isPlayer1)
    }
    
    func createGrid() {
        let player1Moves = Game.history.grabPlayerMoves(playerID: 0)
        let player2Moves = Game.history.grabPlayerMoves(playerID: 1)
        
        for i in 0 ..< grid.count {
            
            grid[i].setImage(X_O: 0)
        }
        
        
        for i in 0 ..< player1Moves.count {
            grid[player1Moves[i]] = TTTButton(loc_X_O: VALUES.O.rawValue)
        }
        for i in 0 ..< player2Moves.count {
            grid[player2Moves[i]] = TTTButton(loc_X_O: VALUES.X.rawValue)
        }
    }
    
    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        
        for all in grid {
            if all.X_O == VALUES.O.rawValue {
                items.append(URLQueryItem(name: "Value", value: "\(VALUES.O.rawValue)"))
            }else if all.X_O == VALUES.X.rawValue {
                items.append(URLQueryItem(name: "Value", value: "\(VALUES.X.rawValue)"))
            } else {
                 items.append(URLQueryItem(name: "Value", value: "\(VALUES.BLANK.rawValue)"))
            }
        }
        items.append(URLQueryItem(name: "Player", value: "\(Game.players.isPlayer1)"))
        return items
    }
    init() {
        createGrid()
    }
    
    init?(message: MSMessage?) {
        guard let msgURL = message?.url else { return nil }
        guard let URLComponents = NSURLComponents(url: msgURL, resolvingAgainstBaseURL: false), queryItems = URLComponents.queryItems else { return nil }
        
        setUpBoard(items: queryItems)
        
        
    }
    
    func renderBoard() -> UIImage? {
        guard let partsImage = renderFromSKScene(scene: Game.sceneTreeToRender) else { return nil }
        
        let outputSize: CGSize
        let gridSize: CGSize
        
        let scale = min((stickerProperties.size.width - stickerProperties.opaquePadding.width) / partsImage.size.height, (stickerProperties.size.height - stickerProperties.opaquePadding.height) / partsImage.size.width)
        
        gridSize = CGSize(width: partsImage.size.width * scale, height: partsImage.size.height * scale)
        outputSize = stickerProperties.size
        
        //scale the image to the correct size
        let renderer = UIGraphicsImageRenderer(size: outputSize)
        let image = renderer.image { context in
            let backgroundColour = UIColor.clear()
            backgroundColour.setFill()
            context.fill(CGRect(origin: CGPoint.zero, size: stickerProperties.size))
            
            var drawRect = CGRect.zero
            drawRect.size = gridSize
            drawRect.origin.x = 0.0
            drawRect.origin.y = 0.0
            partsImage.draw(in: drawRect)
        }
        
        return image
    }
    
    func renderFromSKScene(scene: [SKSpriteNode]?) -> UIImage?{
        // take the nodes from a scenegraph and spit out an image
        
        if let backNode = scene?.filter({$0.name == "grid"}).first {
            let width = backNode.frame.width
            let height = backNode.frame.height
            
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0.0)
            let imageToDraw = UIImage(cgImage: backNode.texture!.cgImage())
            imageToDraw.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
            var remainingChildren = scene
            remainingChildren!.removeObject(object: backNode)
            for all in remainingChildren! {
                print(all.name)
                let image = UIImage(cgImage: all.texture!.cgImage())
                print(all.position)
                print(backNode.position)
                print(all.position - backNode.position)
                //coordinates in the y-axis are flipped for some reason
                image.draw(in: CGRect(origin: CGPoint(x: all.position.x - backNode.position.x ,y: height - ((all.position.y + all.frame.height) - backNode.position.y)), size: CGSize(width: all.frame.width, height: all.frame.height)))
                
                
                
            }
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
            
        }
        return nil
    }
    
    //puts together the pieces of the board
    func renderParts() ->UIImage? {
        //find the used moves and draw those too
        
        let width = background.size.width / 3
        let height = background.size.height / 3
        
        var positions = [CGPoint]()
        var images = [UIImage?]()
        
        for i in 0 ..< grid.count{
            
            let xPos = (width * CGFloat(i % 3))
            let yPos = (height * CGFloat(i / 3))
            if grid[i].imageView?.image != nil {
                positions.append(CGPoint(x: xPos, y: yPos))
                images.append(grid[i].imageView?.image)
            }
        }
        UIGraphicsBeginImageContextWithOptions(background.size, false, 0.0)
        background.draw(in: CGRect(origin: CGPoint.zero, size: background.size))
        
        for i in 0 ..< positions.count {
            if images[i] != nil {
                images[i]?.draw(in: CGRect(origin: positions[i], size: CGSize(width: width, height: height)))
            }
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    struct stickerProperties {
        private static let size = CGSize(width: 500.0, height: 500.0)
        private static let opaquePadding = CGSize(width: 60.0, height: 10.0)
    }
    
}

class TTTButton : UIButton {
    
    var checked : Bool
    //-1 blank, 0 - O, 1 - X
    var X_O : Int
    var checkable : Bool
    
    init( loc_X_O : Int) {
        X_O = loc_X_O
        checked = false
        checkable = true
        super.init(frame: CGRect.zero)
        setImage(X_O: X_O)
    }
    
    required init?(coder aDecoder: NSCoder) {
        X_O = -1
        checked = false
        checkable = false
        
        super.init(coder: aDecoder)
    }
    
    func setImage( X_O: Int) {
        self.X_O = X_O
        if (X_O == VALUES.O.rawValue) {
            self.setImage(UIImage(named: "O"), for: [])
        } else if (X_O == VALUES.X.rawValue) {
            self.setImage(UIImage(named: "X"), for: [])
        } else {
            self.setImage(nil, for: [])
        }
    }
}

enum VALUES : Int { // let's make this less confusing
    case X = -1
    case O = 1
    case BLANK = 0
    
}

extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
