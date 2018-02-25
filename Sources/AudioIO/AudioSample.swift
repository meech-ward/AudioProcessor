//
//  AudioSample.swift
//  AudioProcessor
//
//  Created by Sam Meech-Ward on 2017-11-22.
//

import Foundation

/// Data about a peice of audio at a specific point in time
public struct AudioSample {
    
    /// The time of this sample from the start of the file
    public let time: TimeInterval

//MARK: Data I can get from a framework like AudioKit

    /// Detected amplitude
    public let amplitude: Double?
    
    /// Detected amplitude
    public let rightAmplitude: Double?
    
    /// Detected amplitude
    public let leftAmplitude: Double?
    
    /// Detected frequency
    public let frequency: Double?

//MARK:  Data I can get from a framework like AVFoundation

    /// power, in decibels
    public let power: Float?
    
    public init(time: TimeInterval, amplitude: Double? = nil, rightAmplitude: Double? = nil, leftAmplitude: Double? = nil, frequency: Double? = nil, power: Float? = nil) {
        self.time = time
        self.amplitude = amplitude
        self.frequency = frequency
        self.leftAmplitude = leftAmplitude
        self.rightAmplitude = rightAmplitude
        self.power = power
    }
}
