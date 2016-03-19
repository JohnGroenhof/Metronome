//
//  MachEngine.swift
//  Metronome
//
//  Created by John Groenhof on 3/16/16.
//  Copyright © 2016 John Groenhof. All rights reserved.
//

import Foundation


class MachEngine {
    

    var interval = 100.0 // ms
    
    
    let akMetronome = SetupAKMetronome()
    
    var timebaseInfo = mach_timebase_info_data_t()

    let nanoSecondToSeconds = 1000000.0
    
    
    // let intervalInNanoseconds = UInt64(interval * nanoSecondToSeconds)
    
    // var isPlaying = false
    
//    static uint64_t nanos_to_abs(uint64_t nanos) {
//    return nanos * timebase_info.denom / timebase_info.numer;
//    }
    
    
    
    
    func intervalInNanos(intervalInMS: Double) -> UInt64 {
        return UInt64(interval * nanoSecondToSeconds)
    }
    
    
    func nanosToAbs(intervalInMS: Double) -> UInt64 {
        if timebaseInfo.denom == 0  {
            mach_timebase_info(&timebaseInfo)
        }
        
        let nanos = intervalInNanos(intervalInMS)
        
        return nanos * UInt64(timebaseInfo.denom) / UInt64(timebaseInfo.numer)
    
    }
    
    
    func machTimer() {
        let intervalInAbs = self.nanosToAbs(self.interval)
        dispatch_async(dispatch_get_global_queue( QOS_CLASS_USER_INTERACTIVE, 0), {
            while true {
                // self.b.start()
                // let nanoSecondToSeconds = 1000000.0
                // let intervalInNanoseconds = UInt64(self.interval * nanoSecondToSeconds)
                
                
                mach_wait_until(mach_absolute_time() + intervalInAbs)
                
                self.update()
                
                // self.b.stop()
                // let measuredInterval = self.b.milliseconds
                // self.intervalControl(measuredInterval)
            }
        })
    }
    
    
    func update() {
        // clickSampler.playNote(60)
        akMetronome.clickSampler.playNote(69)
        
    }
    
    
    
    
    
    
    
    

    
    
    
    
    
    
    
}



/*

class TimerTest : NSObject {
    var b = Benchmarker()
    let interval = 100.0 // ms
    
    var highestLatency = 0.0 // ms
    var offsetSum = 0.0
    var count = 1.0
    
    
    
    func intervalControl(measuredInterval: Double) {
        let measurement = (measuredInterval - interval).absoluteValue()
        if measurement > highestLatency {
            highestLatency = measurement
        }
        offsetSum += measurement
        let averageOffset = offsetSum / count++
        if count % 100 == 0 {
            print("Largest offset \(highestLatency)ms - average offset \(averageOffset)ms")
        }
    }
    
    func machTimer() {
        dispatch_async(dispatch_get_global_queue( QOS_CLASS_USER_INTERACTIVE, 0), {
            while true {
                self.b.start()
                let nanoSecondToSeconds = 1000000.0
                let intervalInNanoseconds = UInt64(self.interval * nanoSecondToSeconds)
                mach_wait_until(mach_absolute_time() + intervalInNanoseconds)
                
                self.update()
                
                self.b.stop()
                let measuredInterval = self.b.milliseconds
                self.intervalControl(measuredInterval)
            }
        })
    }
    
    
    func update() {
        clickSampler.playNote(60)
        
        
    }
    
}

struct Benchmarker {
    static var t = mach_timebase_info(numer: 0, denom: 0)
    var startTime = UInt64(0)
    var duration = UInt64(0)
    
    var milliseconds: Double {
        return Double(duration) / 1_000_000
    }
    
    init() {
        if Benchmarker.t.denom == 0 {
            mach_timebase_info(&Benchmarker.t)
        }
    }
    
    mutating func start() {
        startTime = mach_absolute_time()
    }
    
    mutating func stop() {
        let delta = mach_absolute_time() - startTime
        duration = (delta * UInt64(Benchmarker.t.numer)) / UInt64(Benchmarker.t.denom)
    }
    
}


*/























