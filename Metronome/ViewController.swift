//
//  ViewController.swift
//  Metronome
//
//  Created by John Groenhof on 1/25/16.
//  Copyright © 2016 John Groenhof. All rights reserved.
//

import UIKit

// TODO: Implement Tick accent/bars into interface
class ViewController: UIViewController {
    
    
    
    // MARK: Constants
    let metroLoop = MetronomeEngine()
    let maxBPM = 250
    let minBPM = 1
    
    // MARK: Variables
    var interval = 0.0
    var playState = 0
    var timer: Timer!
    
    var bpm: Int = 80 {
        
        // didSet is property observer, so the bpmLabel updates when bpm is set.
        didSet {
            bpmOutlet.text = String(bpm)
            interval = bpmInMilliseconds(bpm)
            metroLoop.triggerTime = interval
            
            print("\(bpmInMilliseconds(bpm))")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bpm = 80
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    // MARK: - FUNCTIONS

    // converts BPM into millisecond double value(actually seconds)
    // 60 = 1.0, 80 = 0.75, etc.
    func bpmInMilliseconds(_ beats: Int) -> Double {
        
        let ms = (60 / Double(beats))
        return ms
        
    }
    
    // Function for tap and hold on bpm +/- buttons
    func bpmHold(_ sender: AnyObject) {
        
        if sender.tag == 4 { //sender.tag = 4 is UP BUTTON
            if bpm < maxBPM { bpm += 1 }
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(ViewController.rapidUp), userInfo: nil, repeats: true)
        }
        else if sender.tag == 3 { //sender.tag = 3 is DOWN BUTTON
            if bpm > minBPM { bpm -= 1 }
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(ViewController.rapidDown), userInfo: nil, repeats: true)
        }
        
    }
    
    // fires every time a bpm button is released (inside or out)
    func bpmRelease(_ sender: AnyObject) {
        timer.invalidate()
    }
    
    // increments BPM
    func rapidUp() {
        if bpm < maxBPM { bpm += 1 }
        else { timer.invalidate() }
    }
    
    // Decrements BPM
    func rapidDown() {
        if bpm > minBPM { bpm -= 1 }
        else { timer.invalidate() }
    }
    
    
    


    
    
    // MARK:  - OUTLETS AND ACTIONS
    
    @IBOutlet var bpmOutlet: UILabel!
    
    @IBOutlet var startStopOutlet: UIButton!

    @IBAction func startStopButton(_ sender: AnyObject) {
        
        // Checks if the metronome is already playing or not, then starts or stops it.
        if playState == 0 {
            playState = 1
            
            // Start the metronome
            metroLoop.startLoop()
            
            // Set button title to "Stop"
            startStopOutlet.setTitle("Stop", for: UIControlState())
            
        } else {
            playState = 0
            
            // Stop the metronome
            metroLoop.stopLoop()
            // set button title back to "Start"
            startStopOutlet.setTitle("Start", for: UIControlState())
        }
        
        
    }

    

    
    
    // Up Button tag is 4
    // bpm + Touch Down
    @IBAction func bpmUpTouchDown(_ sender: AnyObject) {
        bpmHold(sender)
    }
    
    // bpm + Touch Up Inside
    @IBAction func bpmUpTouchUpInside(_ sender: AnyObject) {
        bpmRelease(sender)
    }
    
    // bpm + Touch Up Outside
    @IBAction func bpmUpTouchUpOutside(_ sender: AnyObject) {
        bpmRelease(sender)
    }
    
    

    // Down Button tag is 3
    // bpm - Touch Down
    @IBAction func bpmDownTouchDown(_ sender: AnyObject) {
        bpmHold(sender)
    }
    
    // bpm - Touch Up Inside
    @IBAction func bpmDownTouchUpInside(_ sender: AnyObject) {
        bpmRelease(sender)
    }
    // bpm - Touch Up Outside
    @IBAction func bpmDownTouchUpOutside(_ sender: AnyObject) {
        bpmRelease(sender)
    }



    
}


public struct BarsWithAccents {
    static let threeFour = [1, 0, 0]
    static let fourFour =  [1, 0, 0, 0]
    static let fiveFour =  [1, 0, 0, 0, 0]
    
}
