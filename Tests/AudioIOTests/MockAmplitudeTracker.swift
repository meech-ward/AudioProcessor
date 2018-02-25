//
//  MockAmplitudeTracker.swift
//  AudioIOTests
//
//  Created by Sam Meech-Ward on 2018-01-12.
//

@testable import AudioIO

class MockAudioAmplitudeTracker: MockStartAndStoppable, AudioAmplitudeTracker {
  func setAmplitude(_ amplitude: Double) {
    self.amplitude = amplitude
  }
  var amplitude: Double?
  
  var rightAmplitude: Double?
  
  var leftAmplitude: Double?
}
