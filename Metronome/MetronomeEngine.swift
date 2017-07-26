//
//  MetronomeLoop.swift
//  Metronome
//
//  Created by John Groenhof on 1/25/16.
//  Copyright © 2016 John Groenhof. All rights reserved.
//

import UIKit

// Metronome timer using CADisplayLink
open class MetronomeEngine {
    
    var displayLink: CADisplayLink!
    var triggerTime: Double
    var counter: Int
    var stamp: CFTimeInterval
    var barArray: [Int]?
    var diffFires: [Double]

    let akMetronome: SetupAKMetronome



    init() {
        triggerTime = 0
        counter = 0
        stamp = 0.0
        barArray = nil
        diffFires = []
        akMetronome = SetupAKMetronome()
    }
    
    
    init(bar: [Int]) {
        
        triggerTime = 0
        counter = 0
        stamp = 0.0
        barArray = bar
        diffFires = []
        akMetronome = SetupAKMetronome()
    }
    
    
    
    // Called every frame from startLoop's CADisplayLink call
    @objc fileprivate func callTickTock(_ sender: CADisplayLink) {
        
        // sets initial timestamp and plays first click
        if stamp == 0.0 {
            self.tickOrTock()
            stamp = sender.timestamp
        }
        
        
        // sets the diff equal to elapsed time since last click
        let diff = sender.timestamp - stamp
        
        // tests
        print("stamp:            \(stamp)")
        print("sender.timestamp: \(sender.timestamp)")
        print("diff:             \(diff)")
        
        // Checks if the elapsed time is still less than the target interval
        //  and does nothing if it is.
        if diff < triggerTime {
            return
        }
        
        // adds an entry to the diffFires array to record the average fire interval.
        diffFires.append(diff)
        
        // Execute code block and set stamp
        self.tickOrTock()
        stamp = sender.timestamp
        
    }

    
    fileprivate func tickOrTock() {
        
        // Just this block runs if there are no accents needed
        if barArray == nil {
            
            akMetronome.clickSampler.play()
            return
        }
        
        
        // a 1 in barArray fires the accent note
        if barArray![counter] == 1 {
            
            akMetronome.accentSampler.play()
            
        } else if barArray![counter] == 0 { // a 0 in barArray fires regular note
            
            akMetronome.clickSampler.play()
            
        }
        
        
        // counter to loop through barArray
        if counter == barArray!.count - 1 {
            counter = 0
        } else {
            counter += 1
        }
        
    }
    
    
    
    
    
    // Starts the clicking
    open func startLoop() {
        
        DispatchQueue.main.async { () -> Void in
            self.displayLink = CADisplayLink(target: self, selector: #selector(MetronomeEngine.callTickTock(_:)))
            self.displayLink.frameInterval = 1
            self.displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        }
        
    }

    


    // Stops the clicking
    open func stopLoop() {
        displayLink.invalidate()
        displayLink = nil
        
        // prints the average interval once the Stop button is pressed.
        // Note: Don't change BPM while metronome is playing
        let averageDiffFired: Double = (diffFires as AnyObject).value(forKeyPath: "@avg.self") as! Double
        print(averageDiffFired)
    }
    
    
}
