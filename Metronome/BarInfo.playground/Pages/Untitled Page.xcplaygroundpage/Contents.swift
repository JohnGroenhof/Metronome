//: Playground - noun: a place where people can play

import UIKit

struct Files {
    
    struct Audio {
        
        static let bongo1hi = (name: "Bongo Hi", fileName: "bongo1hi")
        static let bongo1lo = (name: "Bongo Low", fileName: "bongo1lo")
        static let bongoArr = [bongo1hi, bongo1lo]
        
        static let clap1Hi = (name: "Clap Hi", fileName: "clap1hi")
        static let clap1Lo = (name: "Clap Low", fileName: "clap1lo")
        static let clap1Arr = [clap1Hi, clap1Lo]
        
        static let clave1Hi = (name: "Clave Hi", fileName: "clave1hi")
        static let clave1Lo = (name: "Clave Low", fileName: "clave1lo")
        static let clave1Arr = [clave1Hi, clave1Lo]
        
        static let clave2Hi = (name: "Clave 2 Hi", fileName: "clave2hi")
        static let clave2Lo = (name: "Clave 2 Low", fileName: "clave2lo")
        static let clave2Arr = [clave2Hi, clave2Lo]
        
        static let digital1Hi = (name: "Digi Hi", fileName: "digital1hi")
        static let digital1Lo = (name: "Digi Low", fileName: "digital1lo")
        static let digital1Arr = [digital1Hi, digital1Lo]
        
        static let digital2Hi = (name: "Digi 2 Hi", fileName: "digital2hi")
        static let digital2Lo = (name: "Digi 2 Low", fileName: "digital2lo")
        static let digital2Arr = [digital2Hi, digital2Lo]
        
        static let digital3Hi = (name: "Digi 3 Hi", fileName: "digital3hi")
        static let digital3Lo = (name: "Digi 3 Low", fileName: "digital3lo")
        static let digital3Arr = [digital3Hi, digital3Lo]
        
        static let djembe1Hi = (name: "Djembe Hi", fileName: "djembe1hi")
        static let djembe1Lo = (name: "Djembe Low", fileName: "djembe1lo")
        static let djembe1Arr = [djembe1Hi, djembe1Lo]
        
        static let perc1Hi = (name: "Perc Hi", fileName: "perc1hi")
        static let perc1Lo = (name: "Perc Low", fileName: "perc1lo")
        static let perc1Arr = [perc1Hi, perc1Lo]
        
        static let stab1Hi = (name: "Stab Hi", fileName: "stab1hi")
        static let stab1Lo = (name: "Stab Low", fileName: "stab1lo")
        static let stab1Arr = [stab1Hi, stab1Lo]
        
        static let allFilesArray = [bongo1hi, bongo1lo, clap1Hi, clap1Lo,
                                    clave1Hi, clave1Lo, clave2Hi, clave2Lo,
                                    digital1Hi, digital1Lo, digital2Hi, digital2Lo,
                                    digital3Hi, digital3Lo, djembe1Hi, djembe1Lo,
                                    perc1Hi, perc1Lo, stab1Hi, stab1Lo]
        
        
    }
}

class BarInfo {
    
    
    var audioFileStrings = Files.Audio.clave1Arr
    
    var clickFileString: String {
        get {
            return audioFileStrings[1].fileName
        }
    }
    
    var timeSignatureNumer: Int
    var timeSignatureDenom: Int
    var noteSubdivision: Int
    
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
        
        //
        // Midi File Naming:
        // Numer    Denom   Subdivision Tracks
        // 5        4       4           5
        // "5.4.4.5"
        //
        get {
            let name = "\(timeSignatureNumer).\(timeSignatureDenom).\(noteSubdivision).\(numOfMidiTracks)"
            return name
        }
    }
    
    
    
    
    var accentArray:[Int]
    
    init (timeSigNumer: Int, timeSigDenom: Int, subdivision: Int) {
        
        timeSignatureNumer = timeSigNumer
        timeSignatureDenom = timeSigDenom
        noteSubdivision = subdivision
        
        
        accentArray = Array(count: timeSignatureNumer, repeatedValue: 1)
        accentArray[0] = 2
        
    }
    
}



let bar = BarInfo(timeSigNumer: 7, timeSigDenom: 4, subdivision: 8)

bar.numOfMidiTracks



bar.midiFileName    



