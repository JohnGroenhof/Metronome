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
    
    
    
    var audioFileArr = AudioFiles.clave1Arr
    var accentFileString:   String { return audioFileArr[0].fileName }
    var clickFileString:    String { return audioFileArr[1].fileName }
    
    
    // Accent array values:
    // 0 - mute
    // 1 - click
    // 2 - accent
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

        accentArray = Array(count: timeSignatureNumer, repeatedValue: 1)
        accentArray![0] = 2
        
    }
    
    func setBar(timeSigNumer: Int, timeSigDenom: Int, subdivision: Int) {
        
        timeSignatureNumer = timeSigNumer
        timeSignatureDenom = timeSigDenom
        noteSubdivision = subdivision
        
        accentArray = nil
        
        accentArray = Array(count: timeSignatureNumer, repeatedValue: 1)
        accentArray![0] = 2
        
        
    }
    
}