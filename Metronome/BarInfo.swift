//
//  BarInfo.swift
//  Metronome
//
//  Created by John Groenhof on 3/19/16.
//  Copyright © 2016 John Groenhof. All rights reserved.
//

import Foundation


class BarInfo {
    
    var timeSignatureNumer: Int
    var timeSignatureDenom: Int
    var noteSubdivision: Int
    
    var clickFileString: String // "CLAV1_p25"
    var accentFileString: String // "CLAV2_p25"
    
    var accentArray:[Int]?
    
    // Number of MIDI Instrument tracks. The midi file will have
    //   numOfMidiTracks + 1 to account for the tempo track.
    var numOfMidiTracks: Int {
        
        // Number of tracks can be calculated with numer/denom * noteSubdivision.
        //  ie. 7/4 with 8th note subdivision = 14 tracks
        get {
            let tracks = Int(Double(timeSignatureNumer) / Double(timeSignatureDenom) * Double(noteSubdivision))
            return tracks
        }
    }
    
    
    var midiFileName: String {
        
        // Midi File Naming:
        // Numer.Denom.Subdivision.Tracks
        // "5.4.4.5"
        get {
            let name = "\(timeSignatureNumer).\(timeSignatureDenom).\(noteSubdivision).\(numOfMidiTracks)"
            print("Midi File Name:  \(name)")
            return name
        }
    }
    
    
    
    init (timeSigNumer: Int, timeSigDenom: Int, subdivision: Int) {
        
        timeSignatureNumer = timeSigNumer
        timeSignatureDenom = timeSigDenom
        noteSubdivision = subdivision
        
        clickFileString = Files.Audio.clave1Lo
        accentFileString = Files.Audio.clave1Hi
        
        accentArray = Array(count: timeSignatureNumer, repeatedValue: 0)
        accentArray![0] = 1
        
    }
    
    func setBar(timeSigNumer: Int, timeSigDenom: Int, subdivision: Int) {
        
        timeSignatureNumer = timeSigNumer
        timeSignatureDenom = timeSigDenom
        noteSubdivision = subdivision
        
        accentArray = nil
        
        accentArray = Array(count: timeSignatureNumer, repeatedValue: 0)
        accentArray![0] = 1
        
        
    }
    
}