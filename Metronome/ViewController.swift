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
    // let metroLoop = MetronomeEngine()
    // let avae = AudioEngine()
    let seq = Sequencer()
    
    
    let maxBPM = 1000
    let minBPM = 1
    
    // MARK: Variables
    var interval = 0.0
    var playState = 0
    var timer: NSTimer!
    var timerStartTime: NSDate!
    var accentToggleBool = true

    
    var bpm: Int = 80 {
        
        // didSet is property observer, so the bpmLabel updates when bpm is set.
        didSet {
            bpmOutlet.text = String(bpm)
            interval = bpmInMilliseconds(bpm)
            
            
            // metroLoop.triggerTime = interval
            // avae.bps = interval
            seq.setBPM(bpm)
            
            
            print("\(bpmInMilliseconds(bpm))")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bpm = 80
        
        // let mach = MachEngine()
        // mach.machTimer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    // MARK: - FUNCTIONS

    // converts BPM into millisecond double value(actually seconds)
    // 60 = 1.0, 80 = 0.75, etc.
    func bpmInMilliseconds(beats: Int) -> Double {
        
        let ms = (60 / Double(beats))
        return ms - 0.008
        
    }
    
    // Function for tap and hold on bpm +/- buttons
    func bpmHold(sender: AnyObject) {
        
        if sender.tag == 4 { //sender.tag = 4 is UP BUTTON
            timerStartTime = NSDate()
            if bpm < maxBPM { bpm += 1 }
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "rapidUp", userInfo: nil, repeats: true)
        }
        else if sender.tag == 3 { //sender.tag = 3 is DOWN BUTTON
            timerStartTime = NSDate()
            if bpm > minBPM { bpm -= 1 }
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "rapidDown", userInfo: nil, repeats: true)
        }
        
    }
    
    // fires every time a bpm button is released (inside or out)
    func bpmRelease(sender: AnyObject) {
        if timer.valid { timer.invalidate() }
    }
    
    // increments BPM
    func rapidUp() {
        let interval = abs(timerStartTime.timeIntervalSinceNow)
        
        switch interval {
       
        case 0..<2.5:
            if bpm < maxBPM { bpm += 1 }
            else if timer.valid { timer.invalidate() }
        
        
        case 2.5..<4:
            while bpm % 5 != 0 {
                if bpm < maxBPM { bpm += 3 }
                else if timer.valid { timer.invalidate() }
            }
            if bpm < maxBPM { bpm += 5 }
            else if timer.valid { timer.invalidate() }
        
        
        case 4..<10:
            while bpm % 10 != 0 {
                if bpm < maxBPM { bpm += 7 }
                else if timer.valid { timer.invalidate() }
            }
            if bpm < maxBPM { bpm += 10 }
            else if timer.valid { timer.invalidate() }
        
        
        default:
            if bpm < maxBPM { bpm += 20 }
            else if timer.valid { timer.invalidate() }
        }
        
        
        
    }
    
    // Decrements BPM
    func rapidDown() {
        let interval = abs(timerStartTime.timeIntervalSinceNow)
        
        switch interval {
        
        case 0..<2.5:
            if bpm < maxBPM { bpm -= 1 }
            else if timer.valid { timer.invalidate() }
        
        
        case 2.5..<4:
            while bpm % 5 != 0 {
                if bpm < maxBPM { bpm -= 3 }
                else if timer.valid { timer.invalidate() }
            }
            if bpm < maxBPM { bpm -= 5 }
            else if timer.valid { timer.invalidate() }
        
        
        case 4..<10:
            while bpm % 10 != 0 {
                if bpm < maxBPM { bpm -= 7 }
                else if timer.valid { timer.invalidate() }
            }
            if bpm < maxBPM { bpm -= 10 }
            else if timer.valid { timer.invalidate() }
        
        
        default:
            if bpm < maxBPM { bpm -= 20 }
            else if timer.valid { timer.invalidate() }
        }
        
    }
    
    
    
    


    
    
    // MARK:  - OUTLETS AND ACTIONS
    
    @IBOutlet var bpmOutlet: UILabel!
    
    @IBOutlet var startStopOutlet: UIButton!

    @IBAction func startStopButton(sender: AnyObject) {
        
        // Checks if the metronome is already playing or not, then starts or stops it.
        if playState == 0 {
            playState = 1
            
            // Start the metronome
            // metroLoop.startLoop()
            // avae.play()
            seq.play()
            
            
            
            // Set button title to "Stop"
            startStopOutlet.setTitle("Stop", forState: .Normal)
            
        } else {
            playState = 0
            
            // Stop the metronome
            // metroLoop.stopLoop()
            // avae.stop()
            seq.stop()
            
            // set button title back to "Start"
            startStopOutlet.setTitle("Start", forState: .Normal)
        }
        
        
    }

    

    
    
    // Up Button tag is 4
    // bpm + Touch Down
    @IBAction func bpmUpTouchDown(sender: AnyObject) {
        bpmHold(sender)
    }
    
    // bpm + Touch Up Inside
    @IBAction func bpmUpTouchUpInside(sender: AnyObject) {
        bpmRelease(sender)
    }
    
    // bpm + Touch Up Outside
    @IBAction func bpmUpTouchUpOutside(sender: AnyObject) {
        bpmRelease(sender)
    }
    
    

    // Down Button tag is 3
    // bpm - Touch Down
    @IBAction func bpmDownTouchDown(sender: AnyObject) {
        bpmHold(sender)
    }
    
    // bpm - Touch Up Inside
    @IBAction func bpmDownTouchUpInside(sender: AnyObject) {
        bpmRelease(sender)
    }
    // bpm - Touch Up Outside
    @IBAction func bpmDownTouchUpOutside(sender: AnyObject) {
        bpmRelease(sender)
    }

    @IBOutlet var accentToggleOutlet: UIButton!
    
    @IBAction func AccentToggle(sender: AnyObject) {
        print(accentToggleBool)
        
        if accentToggleBool {
            
            accentToggleOutlet.setTitle("Accent On", forState: .Normal)
            
            
            // BarInfo.accentArray = [0, 0, 0, 0]
            seq.loadSamplesIntoSampler()
            
            accentToggleBool = false
            
        } else if !accentToggleBool {
            
            accentToggleOutlet.setTitle("Accent Off", forState: .Normal)
            
            // BarInfo.accentArray = [1, 0, 0, 0]
            seq.loadSamplesIntoSampler()
            
            accentToggleBool = true
            
        }
        
    }

    @IBOutlet var meterButtonOutlet: UIButton!

    @IBAction func meterButton(sender: AnyObject) {
        
        
        print(meterButtonOutlet.titleLabel!.text)
        if meterButtonOutlet.titleLabel?.text == "4/4" {
            
            meterButtonOutlet.setTitle("5/4", forState: .Normal)

            seq.bar.setBar(5, timeSigDenom: 4, subdivision: 4 )
            seq.changeTimeSignature(seq.bar)
            
            
            if playState == 1 {
                seq.play()
            }
            
            
            
        } else if meterButtonOutlet.titleLabel?.text == "5/4" {
            
            meterButtonOutlet.setTitle("4/4", forState: .Normal)
            
            
            seq.bar.setBar(4, timeSigDenom: 4, subdivision: 4)
            seq.changeTimeSignature(seq.bar)
            
            // seq.accentArray.removeLast()
            // seq.sequencer?.setLength(4)
            // seq.loadOneBarIntoSequencer()
            
            
            if playState == 1 {
                seq.play()
            }
            
        }
        
    }
    
}


public struct BarsWithAccents {
    static let threeFour = [1, 0, 0]
    static let fourFour =  [1, 0, 0, 0]
    static let fiveFour =  [1, 0, 0, 0, 0]
    
}
