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
    
    init(recordable: AudioRecordable, dataTimer: TimerType? = nil, dataClosure: AudioRecorderDataClosure? = nil) {
        self._recordable = recordable
        self.dataClosure = dataClosure ?? {_,_ in }
        self.dataTimer = dataTimer
    }
    
    func start() {
        _recordable.start()
        sendNewDataSample()
        self.dataTimer?.start(self.sendNewDataSample)
    }
    
    /// Create an audio sample and send it to the data closure
    func sendNewDataSample() {
        let power = Float(0);//_recordable.averageDecibelPower(forChannel: 0)
        let time = _recordable.currentTime
        let sample = AudioSample(time: time, power: power)
        self.dataClosure(sample, _recordable)
    }
    
    func stop() {
        _recordable.stop()
        self.dataTimer?.stop()
    }
    
}
