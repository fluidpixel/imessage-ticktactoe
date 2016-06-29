//
//  GameMoveHistory.swift
//  TicTacToe
//
//  Created by Lauren Brown on 22/06/2016.
//  Copyright © 2016 Fluid Pixel. All rights reserved.
/* INTRO:
        A Stucture to store the progession of the game locally in the device and retrieve it on startup
 */
//

import Foundation

class GameMoveHistory {
    
    private let defaultsKey_Player1 = "player_1Moves"
    private let defaultsKey_Player2 = "player_2Moves"
    
    private var player1_Moves :[Int]
    private var player2_Moves :[Int] //Int -> ID of buttons in order of moves
    
    
    
    var boardState: TTTBoard?
    
     init( player1 : [Int], player2 : [Int]) {
        self.player1_Moves = player1
        self.player2_Moves = player2
    }
    
     init() {
        self.player1_Moves = [Int]()
        self.player2_Moves = [Int]()
    }
    
    func addMoves(player: String, moves: Int) {
        if player == "0" {
            if !player1_Moves.contains(moves) {
                player1_Moves.append(moves)
            }
            
        } else {
            if !player2_Moves.contains(moves) {
                player2_Moves.append(moves)
            }
            
            
        }
    }
    
    func removeMoves(player: String, moves: Int) {
        if player == "0" {
            if player1_Moves.contains(moves) {
                player1_Moves.removeObject(object: moves)
            }
            
        }else {
            if player2_Moves.contains(moves) {
                player2_Moves.removeObject(object: moves)
            }
        }
    }
    
    //load previous history
     func load(){
        
        let defaults = UserDefaults.standard()
        self.player1_Moves = [Int]()
        self.player2_Moves = [Int]()
        
        if let player1 = defaults.array(forKey: defaultsKey_Player1) as? [Int] {
            if player1.count > 0 {
                self.player1_Moves = player1
            }
        }
        if let player2 = defaults.array(forKey: defaultsKey_Player2) as? [Int] {
            
            if player2.count > 0 {
                self.player2_Moves = player2
            }
        }
    }
    
    //save/clear history
    func save(clearHistory : Bool) {
        
        let defaults = UserDefaults.standard()
        
        defaults.set((clearHistory) ? nil : player1_Moves, forKey: defaultsKey_Player1)
        defaults.set((clearHistory) ? nil : player2_Moves, forKey: defaultsKey_Player2)
    }
    
    func grabPlayerMoves(playerID: Int) -> [Int] {
        if playerID == 0 {
            return player1_Moves
        } else {
            return player2_Moves
        }
    }
    
    func setBoardState(st: TTTBoard)  {
       boardState = st
    }
}

class Players {
    
    init() {
        player1ID = nil
        player2ID = nil
    }
    
    var player1ID: UUID?
    var player2ID: UUID?
    var isPlayer1 = false
    
    func setupPlayer1(id: UUID) {
        self.player1ID = id
    }
    
    func setupPlayer2(id: UUID) {
        self.player2ID = id
    }
    
    
}

class winConditions {
    let winPatterns: [[Int]] = [[0 ,4, 8], [2, 4, 6], [0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8]]
    
    let x = -1
    let o = 1
    let rows = 3
    let cols = 3
    var boardState = [Int]()
    var rowsResult = [Int]()
    var colResult = [Int]()
    var diagResult = [0, 0]
    
    init() {
        
    }
    
    
    func CheckForWinCondition(board: [URLQueryItem]) -> Bool {
        /*if any row/column adds up to the number of rows/columns then O has won, the negative means X has won
                |O|O|O| = 3
                |X|X|O| = -1
                |O|X|X| = -1, diag = -1
         
        */
        boardState.removeAll()
        rowsResult.removeAll()
        colResult.removeAll()
        
        var i = 0
        for queryItem in board {
            guard let value = queryItem.value else { continue }
            if queryItem.name == "Value" {
                boardState.append(Int(value)!)
                i += 1
            }
        }
        
        for i in 0 ..< rows {
            for j in 0 ..< cols {
                if rowsResult.count <= i {
                    rowsResult.append(0)
                }
                let val = boardState[(i * 3) + j]

                rowsResult[i] += val
            }
        }
        
        for i in 0 ..< cols {
            for j in 0 ..< rows {
                if colResult.count <= i {
                    colResult.append(0)
                }
                let val = boardState[(j * 3) + i]
                
                colResult[i] += val
            }
        }
        print("Row 1: \(rowsResult[0]), Row 2: \(rowsResult[1]), Row 3: \(rowsResult[2])")
        print("Col 1: \(colResult[0]), Col 2: \(colResult[1]), Col 3: \(colResult[2])")
        
        //hard code diagonals for the moment
        diagResult[0] = ((boardState[0] + boardState[4] + boardState[8]))
        diagResult[1] = ((boardState[2] + boardState[4] + boardState[6]))
        print("Diagonal 1: \(diagResult[0]), Diagonal 2: \(diagResult[1])")
        
        if rowsResult[0] == 3 ||  rowsResult[1] == 3 || rowsResult[2] == 3 || colResult[0] == 3 || colResult[1] == 3 || colResult[2] == 3 || diagResult[0] == 3 || diagResult[1] == 3 {
            return true
        } else if rowsResult[0] == -3 ||  rowsResult[1] == -3 || rowsResult[2] == -3 || colResult[0] == -3 || colResult[1] == -3 || colResult[2] == -3 || diagResult[0] == -3 || diagResult[1] == -3 {
            return true
        }
        
        return false
    }
}

extension Array where Element: Equatable {
    
    mutating func removeObject(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}
