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
    private let defaultsKey_LocalPlayer = "LocalPlayer"
    
    private var player1_Moves :[Int]
    private var player2_Moves :[Int] //Int -> ID of buttons in order of moves
    var savedLocalPlayer: Bool
    
     init( player1 : [Int], player2 : [Int]) {
        self.player1_Moves = player1
        self.player2_Moves = player2
        savedLocalPlayer = UserDefaults.standard().bool(forKey: defaultsKey_LocalPlayer)
    }
    
     init() {
        self.player1_Moves = [Int]()
        self.player2_Moves = [Int]()
        savedLocalPlayer = UserDefaults.standard().bool(forKey: defaultsKey_LocalPlayer)
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
        if player != "" {
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
        self.savedLocalPlayer = defaults.bool(forKey: defaultsKey_LocalPlayer)
        
    }
    
    //save/clear history
    func save(clearHistory : Bool) {
        
        let defaults = UserDefaults.standard()
        
        defaults.set((clearHistory) ? nil : player1_Moves, forKey: defaultsKey_Player1)
        defaults.set((clearHistory) ? nil : player2_Moves, forKey: defaultsKey_Player2)
        defaults.set((clearHistory) ? true : savedLocalPlayer, forKey: defaultsKey_LocalPlayer)
    }
    
    //save newly retrieved data
    func save(player1:[Int], player2: [Int], isLocalPlayer1: Bool) {
        
        let defaults = UserDefaults.standard()
        
        defaults.set(player1, forKey: defaultsKey_Player1)
        defaults.set(player2, forKey: defaultsKey_Player2)
        defaults.set(isLocalPlayer1, forKey: defaultsKey_LocalPlayer)
        
        player1_Moves = player1
        player2_Moves = player2
    }
    
    func grabPlayerMoves(playerID: Int) -> [Int] {
        
        if playerID == 0 {
            return player1_Moves
        } else {
            return player2_Moves
        }
    }
    
}


