//
//  AudioRecorder.swift
//  AudioProcessorPackageDescription
//
//  Created by Sam Meech-Ward on 2017-11-21.
//

import Foundation

typealias AudioRecorderDataClosure = ((_ audioSample: AudioSample, _ audioRecordable: AudioRecordable) -> (Void))

public struct AudioRecorder {
    
    public var recordable: AudioRecordable {
        return _recordable
    }
    private let _recordable: AudioRecordable
    private let dataClosure: AudioRecorderDataClosure
    private let dataTimer: TimerType?
    private let powerTracker: AudioPowerTracker?
    private let frequencyTracker: AudioFrequencyTracker?
    
    init(recordable: AudioRecordable, powerTracker: AudioPowerTracker? = nil, frequencyTracker: AudioFrequencyTracker? = nil, dataTimer: TimerType? = nil, dataClosure: AudioRecorderDataClosure? = nil) {
        self._recordable = recordable
        self.dataClosure = dataClosure ?? {_,_ in }
        self.dataTimer = dataTimer
        self.powerTracker = powerTracker
        self.frequencyTracker = frequencyTracker
    }
    
    func start() {
        _recordable.start()
        sendNewDataSample()
        self.dataTimer?.start(self.sendNewDataSample)
    }
    
    /// Create an audio sample and send it to the data closure
    private func sendNewDataSample() {
        let sample = newDataSample()
        self.dataClosure(sample, _recordable)
    }
    
    private func newDataSample() -> AudioSample {
        // Ampiltude
        
        // Fequency
        let frequency = self.frequencyTracker?.frequency
        
        // Power
        let power = powerTracker?.averageDecibelPower(forChannel: 0)
        
        // Recording
        let time = _recordable.currentTime
        
        return AudioSample(time: time, frequency: frequency, power: power)
    }
    
    func stop() {
        _recordable.stop()
        self.dataTimer?.stop()
    }
    
}
