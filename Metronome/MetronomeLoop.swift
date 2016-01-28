//
//  MetronomeLoop.swift
//  Metronome
//
//  Created by John Groenhof on 1/25/16.
//  Copyright © 2016 John Groenhof. All rights reserved.
//

import UIKit

// Metronome timer using CADisplayLink
public class MetronomeLoop {
    
    var internalHandler: () -> () = {}
    var displayLink: CADisplayLink!
    var triggerTime: Double
    var counter: Int
    var stamp: CFTimeInterval
    var diffFires: [Double]

    
    init() {
        triggerTime = 0
        counter = 0
        stamp = 0.0
        diffFires = []
    }
    
    
    
    
    // Called every frame from startLoop's CADisplayLink call
    @objc func update(sender: CADisplayLink) {
        
        // sets initial timestamp and plays first click
        if stamp == 0.0 {
            self.internalHandler()
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
        self.internalHandler()
        stamp = sender.timestamp
        
    }
    
    // Starts the clicking.
    // - parameter handler: Code block to execute
    //
    public func startLoop(handler:()->() ) {
        // trigger =  Int(60 * duration)
        internalHandler = handler
        

        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.displayLink = CADisplayLink(target: self, selector: "update:")
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