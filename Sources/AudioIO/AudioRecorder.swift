//
//  AudioRecorder.swift
//  AudioProcessorPackageDescription
//
//  Created by Sam Meech-Ward on 2017-11-21.
//

import Foundation

public typealias AudioRecorderDataClosure = ((_ audioSample: AudioSample, _ audioRecordable: AudioRecordable) -> (Void))

public struct AudioRecorder {
  
  public var recordable: AudioRecordable {
    return _recordable
  }
  public var isRecording: Bool {
    return _recordable.isRecording
  }
  
  private let _recordable: AudioRecordable
  private let dataClosure: AudioRecorderDataClosure
  private let dataTimer: TimerType?
  private let powerTracker: AudioPowerTracker?
  private let frequencyTracker: AudioFrequencyTracker?
  private let amplitudeTracker: AudioAmplitudeTracker?
  
  public init(recordable: AudioRecordable, powerTracker: AudioPowerTracker? = nil, frequencyTracker: AudioFrequencyTracker? = nil,  amplitudeTracker: AudioAmplitudeTracker? = nil, dataTimer: TimerType? = nil, dataClosure: AudioRecorderDataClosure? = nil) {
    self._recordable = recordable
    self.dataClosure = dataClosure ?? {_,_ in }
    self.dataTimer = dataTimer
    self.powerTracker = powerTracker
    self.frequencyTracker = frequencyTracker
    self.amplitudeTracker = amplitudeTracker
  }
  
  public func start(closure: (@escaping (_ successfully: Bool) -> ()) = {_ in }) {
    sendNewDataSample()
    self.dataTimer?.start(self.sendNewDataSample)
    _recordable.start() { successful in
      closure(successful)
    }
  }
  
  /// Create an audio sample and send it to the data closure
  private func sendNewDataSample() {
    let sample = newDataSample()
    self.dataClosure(sample, _recordable)
  }
  
  private func newDataSample() -> AudioSample {
    // Ampiltude
    let amplitude = self.amplitudeTracker?.amplitude
    let leftAmplitude = self.amplitudeTracker?.leftAmplitude
    let rightAmplitude = self.amplitudeTracker?.rightAmplitude
    
    // Fequency
    let frequency = self.frequencyTracker?.frequency
    
    // Power
    let power = powerTracker?.averageDecibelPower(forChannel: 0)
    
    // Recording
    let time = _recordable.currentTime
    
    return AudioSample(time: time, amplitude: amplitude, rightAmplitude: rightAmplitude, leftAmplitude: leftAmplitude, frequency: frequency, power: power)
  }
  
  public func stop(closure: (@escaping (_ successfully: Bool) -> ()) = {_ in }) {
    _recordable.stop() { successful in
      closure(successful)
    }
    self.dataTimer?.stop()
  }
  
}
