//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Lauren Brown on 17/06/2016.
//  Copyright © 2016 Fluid Pixel. All rights reserved.
//

import UIKit
import Messages
import SpriteKit

struct Game {
    static let history = GameMoveHistory()
    static let players = Players()
    static let winCondition = winConditions()
    static var initial = false
    static var sceneTreeToRender: [SKSpriteNode]?
}

class MessagesViewController: MSMessagesAppViewController {
    
    var gameEnd = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func presentViewController(for conversation: MSConversation, with presentationStyle: MSMessagesAppPresentationStyle) {
        
        let controller: UIViewController
        
        let msg = conversation.selectedMessage
        if let msgURL = msg?.url  {
            if let URLComponents = NSURLComponents(url: msgURL, resolvingAgainstBaseURL: false), queryItems = URLComponents.queryItems {
                for all in queryItems {
                    if all.name == "State" {
                        if all.value == "Win" || all.value == "Draw" { //might want more logic in here later
                            gameEnd = true
                        }
                    }
                }
            }
        }
        
        if presentationStyle == .compact {
            controller = createTTTController()
        } else if !gameEnd{
            //if game is won have a different view, otherwise prompt the next move
            controller = createMoveController(conversation: conversation)
        } else {
            
            Game.initial = true
            controller = createTTTController()
            gameEnd = false
        }
        
        
        
        // Remove any existing child controllers.
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        addChildViewController(controller)
        
        controller.view.frame = view.bounds
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        
        controller.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        controller.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        controller.didMove(toParentViewController: self)
    }
    
    private func createTTTController() -> UIViewController {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: TicTacToeVC.storyBoardID) as? TicTacToeVC else {
            fatalError("Unable to instantiate view controller")
        }
        
        controller.delegate = self
        return controller
    }
    
    private func createMoveController(conversation: MSConversation) -> UIViewController {
        
        guard let controller = storyboard?.instantiateViewController(withIdentifier: MoveViewController.storyboardID) as? MoveViewController else {
            fatalError("Unable to instantiate view controller")
        }
        var board = TTTBoard()
        if conversation.selectedMessage != nil {
             board = TTTBoard(message: conversation.selectedMessage )!
        }
        
        controller.delegate = self
        controller.gridValues = board
        //print("Player 1: \(Game.players.player1ID), || Player 2: \(Game.players.player2ID)")
        print("\nLocal Player: \(Game.players.isPlayer1)")
        controller.player = (Game.players.isPlayer1) ?  "0" : "1"
        return controller
    }
    
    func composeMessage(session: MSSession? = nil) {
       
        var components = URLComponents()
        let layout = MSMessageTemplateLayout()
        
        let localBoard = TTTBoard()
        components.queryItems = localBoard.queryItems
        if Game.winCondition.boardState.count <= 0 {
            Game.winCondition.setupBoard(board: localBoard.queryItems)
        }
        layout.image = localBoard.renderBoard()
        var caption = NSLocalizedString("Make Your Move!", comment: "")
        
        if Game.winCondition.CheckForWinCondition(board: components.queryItems!) {
            caption = NSLocalizedString("Haha I Win! Play Again?", comment: "")
            components.queryItems?.append(URLQueryItem(name: "State", value: "Win"))
            gameEnd = true
        } else if Game.winCondition.checkForStalemateCondition() {
            caption = NSLocalizedString("It's a draw! Play Again?", comment: "")
            components.queryItems?.append(URLQueryItem(name: "State", value: "Draw"))
            gameEnd = true
        }
        
        layout.caption = caption
        
        guard let conversation = activeConversation else { fatalError("Expected a conversation") }
        
        let message = MSMessage(session: conversation.selectedMessage?.session ?? MSSession())
        message.url = components.url!
        message.layout = layout

        print("\nLocal Player: \(Game.players.isPlayer1)")
    
        
        conversation.insert(message, localizedChangeDescription: nil) { (error: NSError?) in
            if let error = error {
                print(error)
            }
        }
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        
        // Use this method to prepare for the change in presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func didBecomeActive(with conversation: MSConversation) {
        super.didBecomeActive(with: conversation)
        
        
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        
        Game.history.save(clearHistory: false)
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        //need to undo win condition check here
        
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
        guard let conversation = activeConversation else {fatalError("Expected a conversation") }
        // Use this method to prepare for the change in presentation style.
        presentViewController(for: conversation, with: presentationStyle)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}

extension MessagesViewController : SendDelegate {
    
    func TTTViewControllerNewGame(_ controller: MoveViewController) {
        
        composeMessage()
        controller.initialMove = false
        
    }
    
    func TTTViewControllerNextMove(_ controller: MoveViewController) {
        
        composeMessage()
        dismiss()
    }
    
    func SelectMove(_ controller: TicTacToeVC) {
        requestPresentationStyle(.expanded)
    }
}
//needs another delegate here



