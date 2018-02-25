//
//  AudioRecordable.swift
//  AudioProcessorPackageDescription
//
//  Created by Sam Meech-Ward on 2017-11-21.
//

import Foundation

/// Some sort of recorder
public protocol AudioRecordable {
  
  /// Start Recording
  func start(closure: (@escaping (_ successfully: Bool) -> ()))
  
  /// Stop Recording
  func stop(closure: (@escaping (_ successfully: Bool) -> ()))
  
  /// The time, in seconds, since the beginning of the recording.
  var currentTime: TimeInterval { get }
  
  /// True if recording, false otherwise.
  var isRecording: Bool { get }
}

public protocol AudioPowerTracker {
  /**
   The current average power, in decibels, for the sound being recorded. A return value of 0 dB indicates full scale, or maximum power; a return value of -160 dB indicates minimum power (that is, near silence).
   - parameter: channelNumber: The number of the channel that you want the average power value for.
   */
  func averageDecibelPower(forChannel channelNumber: Int) -> Float
}

public protocol AudioAmplitudeTracker {
  /// Detected amplitude
  var amplitude: Double? { get }
  
  /// Detected amplitude
  var rightAmplitude: Double? { get }
  
  /// Detected amplitude
  var leftAmplitude: Double? { get }
}

public protocol AudioFrequencyTracker {
  /// Detected frequency
  var frequency: Double? { get }
}
