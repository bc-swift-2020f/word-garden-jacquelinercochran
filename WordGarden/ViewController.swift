//
//  ViewController.swift
//  WordGarden
//
//  Created by Jackie Cochran on 9/11/20.
//  Copyright © 2020 Jackie Cochran. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    var wordsToGuess = ["SWIFT", "DOG", "CAT"]
    var currentWordIndex = 0
    var wordToGuess = ""
    var lettersGuessed = ""
    let maxNumberOfWrongGuesses = 8
    var wrongGuessesRemaining = 8
    var wordsGuessedCount = 0
    var wordsMissedCount = 0
    var guessCount = 0
    var audioPlayer: AVAudioPlayer!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let text = guessedLetterField.text!
        guessLetterButton.isEnabled = !(text.isEmpty)
        wordToGuess = wordsToGuess[currentWordIndex]
        wordBeingRevealed.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        updateGameStatusLabels()
        
    }
    

    func updateAfterWinOrLose () {
        //increment currentWordIndex by 1
        //disable guessALetterTextField
        //disable guessALetterButton
        //set play again button .isHidden to false
        
        currentWordIndex += 1
        guessedLetterField.isEnabled = false
        guessLetterButton.isEnabled = false
        playAgainButton.isHidden = false
        
        updateGameStatusLabels()
    }
        
    func updateGameStatusLabels() {
        //update labels at top of screen
        wordsGuessedLabel.text = "Words Guessed: \(wordsGuessedCount)"
        wordsMissedLabel.text = "Words Missed: \(wordsMissedCount)"
        wordsRemainingLabel.text = "Words Remaining: \(wordsToGuess.count - (wordsGuessedCount + wordsMissedCount))"
        wordsInGameLabel.text = "Words in Game: \(wordsToGuess.count)"
        
        
    }
    
    func updateUIAfterGuess(){
        guessedLetterField.resignFirstResponder()
        guessedLetterField.text = ""
        guessLetterButton.isEnabled = false
        
    }
    
    func formatRevealedWord(){
         // format and show revealedWord in wordBeingRevealedLabel to include new guess
        var revealedWord = ""
        for letter in wordToGuess{
            if lettersGuessed.contains(letter){
                revealedWord += "\(letter) "
            }else{
                revealedWord += "_ "
            }
        }
               revealedWord.removeLast()
               wordBeingRevealed.text = revealedWord
    }
    
    
    func drawFlowerAndPlaySound(currentLetterGuessed: String){
        // update image, if needed, and keep track of wrong guesses
        if wordToGuess.contains(currentLetterGuessed) == false{
            wrongGuessesRemaining -= 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                UIView.transition(with: self.flowerImageView,
                                             duration: 0.5,
                                             options: .transitionCrossDissolve,
                                             animations: {self.flowerImageView.image = UIImage(named:"wilt\(self.wrongGuessesRemaining)")})
                           { (_) in
                            
                            if self.wrongGuessesRemaining != 0{
                                self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")
                            }else{
                                self.playSound(name: "word-not-guessed")
                                            UIView.transition(with: self.flowerImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {self.flowerImageView.image = UIImage(named: "flower\(self.wrongGuessesRemaining)")}, completion: nil)
                                }
                               
            }
                self.playSound(name: "incorrect")

            }
            }else{
                playSound(name: "correct")
                }
    }
    
    func guessALetter(){
        // get current letter guessed and add it to all lettersGuessed
        let currentLetterGuessed = guessedLetterField.text!
        lettersGuessed += currentLetterGuessed
        formatRevealedWord()
        
        drawFlowerAndPlaySound(currentLetterGuessed: currentLetterGuessed)
        
    
        // update gameStatusMessageLabel
        guessCount += 1
        var guess = (guessCount == 1 ? "Guess" : "Guesses")
        gameStatusMessageLabel.text = "You've Made \(guessCount) \(guess)"
        
        // Check for win or lose
        if wordBeingRevealed.text!.contains("_") == false {
            gameStatusMessageLabel.text = "You've guessed it! It took you \(guessCount) guesses to guess the word."
            playSound(name: "word-guessed")
            wordsGuessedCount += 1
            updateAfterWinOrLose()
        } else if wrongGuessesRemaining == 0{
            gameStatusMessageLabel.text = "So sorry. You're all out of guesses."
            wordsMissedCount += 1
            updateAfterWinOrLose()
        }
        
        // check to see if you've played all the words
        if currentWordIndex == wordsToGuess.count{
            gameStatusMessageLabel.text! += "\n\n You've tried all of the words! Restart from the beginning?"
        }
    }
    
    
    
    func playSound(name: String){
        
       if let sound = NSDataAsset(name: name){
           do{
               try audioPlayer = AVAudioPlayer(data: sound.data)
               audioPlayer.play()
           }catch{
               print("ERROR: \(error.localizedDescription) Could not initialize AVAudioPlayer object.")
           }

       }else{
           print("ERROR: Could not read data from file")
           }
    }
    

    @IBAction func guessLetterButtonPressed(_ sender: UIButton) {
        //This dismisses the keyboard
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        if currentWordIndex == wordsToGuess.count{
            currentWordIndex = 0
            wordsGuessedCount = 0
            wordsMissedCount = 0

        }
        playAgainButton.isHidden = true
        guessedLetterField.isEnabled = true
        guessLetterButton.isEnabled = false
        wordToGuess = wordsToGuess[currentWordIndex]
        wrongGuessesRemaining = maxNumberOfWrongGuesses
        wordBeingRevealed.text = "_" + String(repeating: " _", count: wordToGuess.count-1)
        guessCount = 0
        flowerImageView.image = UIImage(named: "flower \(maxNumberOfWrongGuesses)")
        lettersGuessed = ""
        gameStatusMessageLabel.text = "You've Made Zero Guesses"
        updateGameStatusLabels()
        
        
        
    }
    
    @IBAction func doneKeyPressed(_ sender: UITextField) {
        guessALetter()
        updateUIAfterGuess()
    }
    
    @IBAction func guessedLetterFieldChanged(_ sender: UITextField) {
        sender.text = String(sender.text?.last ?? " ").trimmingCharacters(in: .whitespaces).uppercased()
        guessLetterButton.isEnabled = !(sender.text!.isEmpty)
        

        
        
    }
    
    
}

