//
//  SetupAKMetronome.swift
//  Metronome
//
//  Created by John Groenhof on 1/25/16.
//  Copyright © 2016 John Groenhof. All rights reserved.
//

import Foundation
import AudioKit


// TODO: Build new tick and tock sounds, possibly using sampler files instead of wav.
// TODO: Try building sounds using AudioKit's synthesis capabilities.
// Todo: Error handling for loading files

// Class for AudioKit implementation. Sets up AK and AKSamplers with 
//    wav files and starts AK.
public class SetupAKMetronome {
    
    
    // let audioKit = AudioKit()
    let clickSampler = AKSampler()
    let accentSampler = AKSampler()

    init() {

        clickSampler.loadWav("cowbell")
        accentSampler.loadWav("cowbellaccent")
        
        // Load AKSamplers into AKMixer
        let samplerMixer = AKMixer(clickSampler, accentSampler)
        
        // Set the sampler mixer to the main audio output
        AudioKit.output = samplerMixer
        // audioKit.output = samplerMixer
        
        AudioKit.start() //Starts AK Engine
        
    }
    
    deinit {
        AudioKit.stop()
    }
  
}


