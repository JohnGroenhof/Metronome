//
//  MetronomeLoop.swift
//  Metronome
//
//  Created by John Groenhof on 1/25/16.
//  Copyright © 2016 John Groenhof. All rights reserved.
//

import UIKit

// Metronome timer using CADisplayLink
public class MetronomeEngine {
    
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
    @objc private func callTickTock(sender: CADisplayLink) {
        
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

    
    private func tickOrTock() {
        
        // Just this block runs if there are no accents needed
        if barArray == nil {
            
            akMetronome.clickSampler.playNote(60)
            return
        }
        
        
        // a 1 in barArray fires the accent note
        if barArray![counter] == 1 {
            
            akMetronome.accentSampler.playNote(58)
            
        } else if barArray![counter] == 0 { // a 0 in barArray fires regular note
            
            akMetronome.clickSampler.playNote(60)
            
        }
        
        
        // counter to loop through barArray
        if counter == barArray!.count - 1 {
            counter = 0
        } else {
            counter += 1
        }
        
    }
    
    
    
    
    
    // Starts the clicking
    public func startLoop() {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.displayLink = CADisplayLink(target: self, selector: "callTickTock:")
            self.displayLink.frameInterval = 1
            self.displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        }
        
    }

    


    // Stops the clicking
    public func stopLoop() {
        displayLink.invalidate()
        displayLink = nil
        
        // prints the average interval once the Stop button is pressed.
        // Note: Don't change BPM while metronome is playing
        let averageDiffFired: Double = (diffFires as AnyObject).valueForKeyPath("@avg.self") as! Double
        print(averageDiffFired)
    }
    
    
}