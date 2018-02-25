//
//  AudioInput.swift
//  AudioIOPackageDescription
//
//  Created by Sam Meech-Ward on 2018-01-12.
//

import Foundation

public struct AudioInput {
  
  let microphone: MicrophoneType & StartAndStopable
  let amplitudeTracker: (AudioAmplitudeTracker & StartAndStopable)?
  
  public var amplitude: Double? {
    return amplitudeTracker?.amplitude
  }
  
  public init (microphone: MicrophoneType & StartAndStopable,
               bufferClosure: @escaping ((UnsafeMutablePointer<Float>, Int) -> (Void)),
               amplitudeTracker: (AudioAmplitudeTracker & StartAndStopable)? = nil) {
    self.microphone = microphone
    self.amplitudeTracker = amplitudeTracker
    microphone.bufferClosure = bufferClosure
  }
  
  public func start() {
    microphone.start()
    amplitudeTracker?.start()
  }
  
  public func stop() {
    microphone.stop()
    amplitudeTracker?.stop()
  }
  
}
