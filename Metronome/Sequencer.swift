//
//  AKSequencer.swift
//  Metronome
//
//  Created by John Groenhof on 3/17/16.
//  Copyright © 2016 Spiraal. All rights reserved.
//

import Foundation
import AudioKit

struct Files {
    
    struct Audio {
        static let clave1Hi =  "CLAV2_p25"
        static let clave1Lo =  "CLAV1_p25"
        
        static let clave2Hi =  "clavehifix"
        static let clave2Lo =  "clavelofix"
        
        static let cowbellHi = "cowbelaccent"
        static let cowbellLo = "cowbell"
    }
}



class Sequencer {
    
    // MARK: - Variables
    var sequencer: AKSequencer?
    var clickSamplerArray: [AKSampler]?
    var samplerMixer: AKMixer?
    var bar = BarInfo(timeSigNumer: 4, timeSigDenom: 4, subdivision: 4)
    
    var rate: Float = 1.0

    var AKIsActive = false
    

    
    // MARK: - Initializer
    init() {

        // initialize samplers
        initSamplerArray(bar.timeSignatureNumer)
        loadSamplesIntoSampler()
        initMixer(bar.timeSignatureNumer)
        initSequencerWithMidi(bar.midiFileName)
        connectSamplerNodesToSequencerTracks()
        
        AKStart()
        
    }
    
    deinit {
        AudioKit.stop()
    }
    
    
    
    
    // MARK: - AudioKit Setup
    func initSamplerArray(timeSigNumer: Int) {
        
        if clickSamplerArray != nil {
            clickSamplerArray = nil
        }
        
        for _ in 0..<timeSigNumer {
            
            if clickSamplerArray == nil {
                clickSamplerArray = [AKSampler()]
            } else {
                clickSamplerArray!.append(AKSampler())
            }
            
        }
        
        print("Click Sampler Array Couunt: \(clickSamplerArray?.count)")
        
    }
    
    
    func loadSamplesIntoSampler() {
        
        var j = 0
        for i in bar.accentArray! {
            
            print(i)
            if i == 1 {
                clickSamplerArray![j].loadWav(bar.accentFileString)
            } else if i == 0 {
                clickSamplerArray![j].loadWav(bar.clickFileString)
            }
            
            j += 1
            
        }
        
    }
    
    
    
    
    
    func initMixer(timeSigNumer: Int) {
        
        // deinit mixer if already initialized
        if samplerMixer != nil {
            samplerMixer = nil
        }
        
        // initialize mixer with first click sampler, then add connections as needed.
        for i in 0..<timeSigNumer {
            
            if samplerMixer == nil {
                samplerMixer = AKMixer(clickSamplerArray![i])
            } else {
                samplerMixer?.connect(clickSamplerArray![i])
            }
            
        }
        
        
        
        AudioKit.output = samplerMixer
        
    }
    
    
    
    func initSequencerWithMidi(filename: String) {
        
        if sequencer != nil {
            sequencer = nil
        }
        
        sequencer = AKSequencer(filename: filename, engine: AudioKit.engine)
        
        sequencer?.setLength(Double(bar.timeSignatureNumer))
        sequencer?.loopOn()
        
        sequencer?.setRate(rate)
        
        
        
    }
    

    
    func connectSamplerNodesToSequencerTracks() {
        var j = 0
        // Get track count of current midi file in sequencer
        let sequencerTrackCount = sequencer?.trackCount
        
        print("Sequencer Track Count: \(sequencerTrackCount)")
        
        // loop through the sequencers midi tracks, starting at 1 (0 is tempo track), 
        //  attaching a AKSampler to each one.
        for track in (sequencer?.avTracks[1..<sequencerTrackCount!])! {
            track.destinationAudioUnit = clickSamplerArray![j].samplerUnit
            
            j += 1
        }
    }
    
    func AKStart() {
        
        if !AKIsActive {
            AudioKit.start()
            AKIsActive = true
        }
    }
    
    func AKStop() {
        
        stop()
        if AKIsActive {
            AudioKit.stop()
            AKIsActive = false
        }
    }
    

    

    
    // MARK: - Methods
    
    func changeTimeSignature(bar: BarInfo) {
        
        AKStop()
        
        initSamplerArray(bar.timeSignatureNumer)
        loadSamplesIntoSampler()
        initMixer(bar.timeSignatureNumer)
        initSequencerWithMidi(bar.midiFileName)
        connectSamplerNodesToSequencerTracks()
        
        AKStart()
        
        
    }

    
    func play() {
        
        sequencer!.play()
    }
    
    
    func stop() {
        
        sequencer!.stop()
    }
    
    
    func setBPM(beats: Int) {
        
        rate = Float(beats) / Float(60)
        
        sequencer!.setRate(rate)
        
        
    }
    
}
























