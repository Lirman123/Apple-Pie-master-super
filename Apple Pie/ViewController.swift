//
//  ViewController.swift
//  Apple Pie
//
//  Created by student on 29.03.2018.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    var listOfWords = [
        "Анастасия",
        "Лиза",
        "Екатирина"
    ]
    
    let incorrectMovesAllowed = 7
    
    var totalWins = 0 {
        didSet{
            newRound(after: 0.5)
        }
    }
    var totalLosses = 0 {
        didSet {
            currentGame.formattedWord = currentGame.word 
            newRound(after: 0.5)
        }
    
    }
    
    var currentGame: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }
    func enableButtons(_ enable: Bool, in view: UIView) {
        if view is UIButton {
            (view as! UIButton).isEnabled = enable
        } else {
            for subview in view.subviews {
                enableButtons(enable, in: subview)
            }
        }
    }
    
    func newRound() {
        guard !listOfWords.isEmpty else {
            enableButtons(false, in: view)
            updateUI()
            return
        }
        let newWord = listOfWords.removeFirst()
        
        currentGame = Game(
            word: newWord.lowercased(),
            incorrectMovesRemaining: incorrectMovesAllowed,
            guessedLetters: []
        )
        
        enableButtons(true, in: view)
        updateUI()
    }
    
    func newRound(after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.newRound()
        }
    }
   
    func updateGameState() {
        if currentGame.incorrectMovesRemaining < 1 {
            totalLosses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
        }
        updateUI()
    }
   
    func updateUI() {
        
        let fileName = "Tree \(currentGame.incorrectMovesRemaining)"
        treeImageView.image = UIImage(named: fileName)
        
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        letters[0] = letters[0].capitalized
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        
        
        scoreLabel.text = "Выигрыши: \(totalWins), проигрыши: \(totalLosses)"
    }
}

