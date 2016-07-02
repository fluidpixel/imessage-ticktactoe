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

class TTTBoard {
    //example grid for testing has been added
    var grid : [TTTButton] = [TTTButton(loc_X_O: -1), TTTButton(loc_X_O: 0), TTTButton(loc_X_O: 0), TTTButton(loc_X_O: 1), TTTButton(loc_X_O: -1), TTTButton(loc_X_O: 1), TTTButton(loc_X_O: 1), TTTButton(loc_X_O: -1), TTTButton(loc_X_O: 0)]
    let background : UIImage = UIImage(named: "grid")!
    
    func setUpBoard(items: [URLQueryItem]) {
        
        for (i, queryItem) in items.enumerated() {
            guard let value = queryItem.value else { continue }
            if queryItem.name == "Value" {
            grid[i].setImage(X_O: Int(value)!)
                
            } else if queryItem.name == "Player" {
                let retValue = value.lowercased() == "true"
                Game.players.isPlayer1 = !retValue
            }
        }
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
        guard let partsImage = renderParts() else { return nil }
        
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
