//
//  WinCondition.swift
//  TicTacToe
//
//  Created by Lauren Brown on 18/07/2016.
//  Copyright © 2016 Fluid Pixel. All rights reserved.
//

import Foundation

//Class for the game's result logic
class winConditions {
    
    let x = -1
    let o = 1
    let rows = 3
    let cols = 3
    var boardState = [Int]()
    var rowsResult = [Int]()
    var colResult = [Int]()
    var diagResult = [0, 0]
    
    init() {
        rowsResult = Array<Int>(repeating: 0, count: rows)
        colResult = Array<Int>(repeating: 0, count: cols)
    }
    
    func setupBoard(board: [URLQueryItem]) {
        //init the boardstate
        
        var i = 0
        for queryItem in board {
            guard let value = queryItem.value else { continue }
            if queryItem.name == "Value" {
                boardState.append(Int(value)!)
                i += 1
            }
        }
        
    }
    
    func addResult(value: Int, index: Int) {
        if index < boardState.count {
            boardState[index] = value
        }
        
        //add result for win conditions
        let first: Int = index / rows
        let second = index % rows
        
        rowsResult[first] += value
        colResult[second] += value
        
        if first == second {
            diagResult[0] += value
        }
        if index == 2 || index == 4 || index == 6 {
            diagResult[1] += value
        }
    }
    
    func removeResult(previousValue: Int, index: Int) {
        if index < boardState.count {
            boardState[index] = 0
        }
        
        //remove result from win condition
        //add result for win conditions
        let first: Int = index / rows
        let second = index % rows
        
        rowsResult[first] -= previousValue
        colResult[second] -= previousValue
        
        if first == second {
            diagResult[0] -= previousValue
        }
        if index == 2 || index == 4 || index == 6 {
            diagResult[1] -= previousValue
        }
    }
    
    func CheckForWinCondition(board: [URLQueryItem]) -> Bool {
        /*if any row/column adds up to the number of rows/columns then O has won, the negative means X has won
         |O|O|O| = 3
         |X|X|O| = -1
         |O|X|X| = -1, diag = -1
         
         */
        //changing this so that it doesn't recalculate
        
        print("Row 1: \(rowsResult[0]), Row 2: \(rowsResult[1]), Row 3: \(rowsResult[2])")
        print("Col 1: \(colResult[0]), Col 2: \(colResult[1]), Col 3: \(colResult[2])")
        print("Diagonal 1: \(diagResult[0]), Diagonal 2: \(diagResult[1])")
        
        if rowsResult[0] == 3 ||  rowsResult[1] == 3 || rowsResult[2] == 3 || colResult[0] == 3 || colResult[1] == 3 || colResult[2] == 3 || diagResult[0] == 3 || diagResult[1] == 3 {
            return true
        } else if rowsResult[0] == -3 ||  rowsResult[1] == -3 || rowsResult[2] == -3 || colResult[0] == -3 || colResult[1] == -3 || colResult[2] == -3 || diagResult[0] == -3 || diagResult[1] == -3 {
            return true
        }
        
        return false
    }
    
    func checkForStalemateCondition() -> Bool {
        // we need to be able to detemine if the game is no longer winnable and give the option to restart
        //The obvious answer is when there's only one move left
        var movesleft = 0
        for all in boardState {
            if all == 0 {
                movesleft += 1
            }
        }
        
        if movesleft == 1 && !(rowsResult[0] == 2 ||  rowsResult[1] == 2 || rowsResult[2] == 2 || colResult[0] == 2 || colResult[1] == 2 || colResult[2] == 2 || diagResult[0] == 2 || diagResult[1] == 2) {
            return true
        } else if movesleft == 1 && !(rowsResult[0] == -2 ||  rowsResult[1] == -2 || rowsResult[2] == -2 || colResult[0] == -2 || colResult[1] == -2 || colResult[2] == -2 || diagResult[0] == -2 || diagResult[1] == -2) {
            return true
        }
        return false
        
    }
}
