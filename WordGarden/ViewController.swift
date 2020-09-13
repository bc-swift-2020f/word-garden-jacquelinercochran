//
//  ViewController.swift
//  WordGarden
//
//  Created by Jackie Cochran on 9/11/20.
//  Copyright © 2020 Jackie Cochran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var wordsGuessedLabel: UILabel!
    @IBOutlet weak var wordsMissedLabel: UILabel!
    @IBOutlet weak var wordsRemainingLabel: UILabel!
    @IBOutlet weak var wordsInGameLabel: UILabel!
    @IBOutlet weak var wordBeingRevealed: UILabel!
    @IBOutlet weak var guessedLetterField: UITextField!
    @IBOutlet weak var guessLetterButton: UIButton!
    @IBOutlet weak var gameStatusMessageLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var flowerImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessedLetterField.text!
        guessLetterButton.isEnabled = !(text.isEmpty)
        
    }

    func updateUIAfterGuess(){
        guessedLetterField.resignFirstResponder()
        guessedLetterField.text = ""
        guessLetterButton.isEnabled = false
    }

    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        //This dismisses the keyboard
       updateUIAfterGuess()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        updateUIAfterGuess()
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        var text = guessedLetterField.text!
        if let lastCharacter = text.last{
            text = String(lastCharacter)
        }else{
           text = ""
        }
        guessLetterButton.isEnabled = !(text.isEmpty)

        
        
    }
    
    
}

