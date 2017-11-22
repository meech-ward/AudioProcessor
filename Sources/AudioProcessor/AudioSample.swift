//
//  AudioSample.swift
//  AudioProcessor
//
//  Created by Sam Meech-Ward on 2017-11-22.
//

import Foundation

/// Data about a peice of audio at a specific point in time
struct AudioSample {
    
    /// The time of this sample from the start of the file
    let time: TimeInterval
    
    /// power, in decibels
    let power: Float
}
