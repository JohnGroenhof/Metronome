//
//  AudioEngine.swift
//  Metronome
//
//  Created by John Groenhof on 2/19/16.
//  Copyright © 2016 Spiraal. All rights reserved.
//


import Foundation
import AVFoundation



///
/// This class will be used to test AVAudioEngine's capabilities.
///

class AudioEngine {
    
    let sampleRate: Double // This assumes all files I'm using are the same format
    
    let sampleBufferLo : AVAudioPCMBuffer
    let sampleBufferHi : AVAudioPCMBuffer
    let barBuffer1 : AVAudioPCMBuffer
    
    let fileLo : AVAudioFile
    let fileHi : AVAudioFile
    
    let engine : AVAudioEngine
    let player : AVAudioPlayerNode
    let mixer : AVAudioMixerNode
    
    var bps: Double
    var samplesInABar : AVAudioFrameCount = 176400
    var samplesInATick : AVAudioFrameCount = 44100
    var samplesInSilence : AVAudioFrameCount = 41092
    
    init() {
        
        sampleRate = 44100
        bps = 1
        
        engine = AVAudioEngine()
        player = AVAudioPlayerNode()
        mixer = engine.mainMixerNode
        // let numOfSamplesInABar = barLengthInSamples(bps)
        
        engine.attachNode(player)
        engine.connect(player, to: mixer, format: mixer.outputFormatForBus(0))
        
        
        let claveLoURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("clavelo", ofType: "m4a")!)
        fileLo = try! AVAudioFile(forReading: claveLoURL)
        
        
        let claveHiURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("clavehi", ofType: "m4a")!)
        fileHi = try! AVAudioFile(forReading: claveHiURL)
        
        sampleBufferLo = AVAudioPCMBuffer(PCMFormat: fileLo.processingFormat,
                                            frameCapacity: AVAudioFrameCount(fileLo.length))
        sampleBufferHi = AVAudioPCMBuffer(PCMFormat: fileHi.processingFormat,
                                            frameCapacity: AVAudioFrameCount(fileHi.length))
        barBuffer1 = AVAudioPCMBuffer(PCMFormat: fileLo.processingFormat,
                                            frameCapacity: AVAudioFrameCount(samplesInABar))
        
        do {
            try fileLo.readIntoBuffer(sampleBufferLo)
            try fileHi.readIntoBuffer(sampleBufferHi)
        } catch {
            
        }
        
        fillBarBuffer(Int(fileLo.length))
        startAVAudioEngine()
    }
    
    
    

    func play() {
        player.play()
    }
    
    func stop() {
        player.pause()
    }
    
    
    
    
    
    private func startAVAudioEngine() {
        do {
            try engine.start()
            print("Engine Started")
        } catch {
            print("Error starting Engine")
        }
    }


    // Figure this shit out
    func fileInfo(file: AVAudioFile) {
        
        samplesInABar = AVAudioFrameCount((Double(file.processingFormat.sampleRate) * bps) * 4)
        samplesInATick = AVAudioFrameCount(samplesInABar / 4)
        samplesInSilence = samplesInATick - AVAudioFrameCount(file.length)
        
        
    }
    
    
//    
//    // Note: There must be a way to calculate and store all of these frame counts easily
//    //          every time the BPM is changed.
//    func getBarLengthInSamples(bps: Double) -> AVAudioFrameCount {
//        
//        return AVAudioFrameCount((Double(sampleRate) * bps) * 4)
//        
//    }
//    
    
    
    
    func fillBarBuffer(fileLength: Int) {
        var j = 0 // frame counter
        
        /// Beat ONE
        for var i in 0..<fileLength {
            barBuffer1.floatChannelData.memory[j] = sampleBufferLo.floatChannelData.memory[i]
            j += 1
            i += 1
        }
        j += Int(samplesInSilence)
        
        
        
        /// Beat TWO
        for var i in 0..<fileLength {
            barBuffer1.floatChannelData.memory[j] = sampleBufferLo.floatChannelData.memory[i]
            j += 1
            i += 1
        }
        j += Int(samplesInSilence)
        
        
        
        /// Beat THREE
        for var i in 0..<fileLength {
            barBuffer1.floatChannelData.memory[j] = sampleBufferLo.floatChannelData.memory[i]
            j += 1
            i += 1
        }
        j += Int(samplesInSilence)
        
        
        
        /// Beat FOUR
        for var i in 0..<fileLength {
            barBuffer1.floatChannelData.memory[j] = sampleBufferLo.floatChannelData.memory[i]
            j += 1
            i += 1
        }
        j += Int(samplesInSilence)
        
        
        
        barBuffer1.frameLength = samplesInABar
        player.scheduleBuffer(barBuffer1, atTime: nil, options: .Loops, completionHandler: nil)
        
        
    }
    
    
    
    
    
    
    
    
    // simplifying this function will require creating an array of each click's start position (j)
    
    func copyOneSampleToBarBuffer(sampleBuffer: AVAudioPCMBuffer, barBuffer: AVAudioPCMBuffer, startAtSample: Int) {
        
        var j = startAtSample
        let sampleBufferFrameCapacity = Int(sampleBuffer.frameCapacity)
        
        for var i in 0..<sampleBufferFrameCapacity {
            barBuffer.floatChannelData.memory[j] = sampleBuffer.floatChannelData.memory[i]
            j += 1
            i += 1
        }
        j += Int(samplesInSilence)
    }
    
    
    
    
}





