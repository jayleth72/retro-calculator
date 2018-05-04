//
//  ViewController.swift
//  retro-calculator
//
//  Created by Jay Letheby on 17/4/18.
//  Copyright © 2018 Jay Letheby solutions. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    // Default Value
    var currentOperation: Operation = Operation.Empty
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundUrl as URL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    @IBAction func numberPressed(btn: UIButton) {
        playSound()
        
        runningNumber += "\(btn.tag)"
        outputLbl.text = runningNumber
    }
    
    @IBAction func onDividedPressed(_ sender: Any) {
        processOperation(op: Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(_ sender: Any) {
        processOperation(op: Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(_ sender: Any) {
        processOperation(op: Operation.Subtract)
    }
    
    @IBAction func onAddPressed(_ sender: Any) {
        processOperation(op: Operation.Add)
    }
    
    @IBAction func onEqualPressed(_ sender: Any) {
        processOperation(op: currentOperation)
    }
    
    @IBAction func onClearPressed(_ sender: Any) {
        playSound()
        leftValStr = ""
        rightValStr = ""
        runningNumber = ""
        outputLbl.text = "0"
        currentOperation = Operation.Empty
    }
    
    func processOperation (op: Operation) {
        playSound()
        
        if currentOperation != Operation.Empty {
            // Run some math
            
            if runningNumber != "" {
                //A user selected am operator, but then selected another operator\
                //without first entering a numner
                rightValStr = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }
          
            currentOperation = op
            
        } else {
            //This is the first time an operator has been presssed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
            
        }
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
}

