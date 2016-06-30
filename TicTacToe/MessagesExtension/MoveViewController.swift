//
//  ViewController.swift
//  TicTacToe
//
//  Created by Lauren Brown on 24/06/2016.
//  Copyright © 2016 Fluid Pixel. All rights reserved.
//

import UIKit

class MoveViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    @IBOutlet weak var Board: UIImageView!
    
    @IBOutlet weak var Grid: UICollectionView!
    
    @IBOutlet weak var Label: UILabel!
    
    @IBOutlet weak var ConfirmButton: UIButton!
    
    static let storyboardID = "Move"
    var gridValues: TTTBoard?
    var initialMove = false
    
    weak var delegate: SendDelegate?
    var player: String?
    
    var selectedIndex: IndexPath?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 45 , height: 45)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        
        
        Grid.collectionViewLayout = layout
        
        Grid.delegate = self
        Grid.dataSource = self
        Board.image = UIImage(named: "grid")
        Label.text = "Player \(Int(player!)! + 1) Make Your Move!"
        //Grid.backgroundColor = UIColor.clear()
        // Do any additional setup after loading the view.
        
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
    @IBAction func ConfirmPressed(_ sender: UIButton) {
        
        if initialMove {
            Game.players.isPlayer1 = true
            delegate?.TTTViewControllerNewGame(self)
        } else {
            delegate?.TTTViewControllerNextMove(self)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TTTCell.reuseIdentifier, for: indexPath) as? TTTCell {
            
            let player1Results = Game.history.grabPlayerMoves(playerID: 0)
            let player2Results = Game.history.grabPlayerMoves(playerID: 1)
            
            cell.images?.image = nil
            
            if player1Results.contains(indexPath.row) {
                cell.images?.image = UIImage(named: "O")
            }else if player2Results.contains(indexPath.row) {
                cell.images?.image = UIImage(named: "X")
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //user has placed their O or X
        
        if let cell = collectionView.cellForItem(at: indexPath) as? TTTCell {
            
            if selectedIndex != nil {
                
                if player == "0" {
                    Game.history.removeMoves(player: player!, moves: selectedIndex!.row)
                    Game.winCondition.removeResult(previousValue: 1, index: selectedIndex!.row)
                } else {
                    Game.history.removeMoves(player: "1", moves: selectedIndex!.row)
                    Game.winCondition.removeResult(previousValue: -1, index: selectedIndex!.row)
                }
            }

            if player == "0" {
                
                Game.history.addMoves(player: player!, moves: indexPath.row)
                Game.winCondition.addResult(value: 1, index: indexPath.row)
                DispatchQueue.main.async(execute: {
                    self.Grid.reloadData()
                })
                
                
            } else{
                Game.history.addMoves(player: "1", moves: indexPath.row)
                Game.winCondition.addResult(value: -1, index: indexPath.row)
                DispatchQueue.main.async(execute: {
                    self.Grid.reloadData()
                })
            }
            selectedIndex = indexPath
        }
        
    }
}

protocol SendDelegate: class {
    func TTTViewControllerNewGame(_ controller: MoveViewController)
    func TTTViewControllerNextMove(_ controller: MoveViewController)
}

class TTTCell : UICollectionViewCell {
    
    @IBOutlet weak var images: UIImageView!
    
    static let reuseIdentifier = "cell"
}
