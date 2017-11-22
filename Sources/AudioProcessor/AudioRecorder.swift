//
//  AudioRecorder.swift
//  AudioProcessorPackageDescription
//
//  Created by Sam Meech-Ward on 2017-11-21.
//

import Foundation

typealias AudioRecorderDataClosure = ((_ audioSample: AudioSample) -> (Void))

public struct AudioRecorder {
    
    private let recordable: AudioRecordable
    private let dataClosure: AudioRecorderDataClosure
    private let dataTimer: TimerType?
    
    init(recordable: AudioRecordable, dataTimer: TimerType? = nil, dataClosure: @escaping AudioRecorderDataClosure = {_ in }) {
        self.recordable = recordable
        self.dataClosure = dataClosure
        self.dataTimer = dataTimer
    }
    
    func start() {
        recordable.start()
        sendNewDataSample()
        self.dataTimer?.start {
            self.sendNewDataSample()
        }
    }
    
    /// Create an audio sample and send it to the data closure
    func sendNewDataSample() {
        let power = recordable.averageDecibelPower(forChannel: 0)
        let time = recordable.currentTime
        let sample = AudioSample(time: time, power: power)
        self.dataClosure(sample)
    }
    
    func stop() {
        recordable.stop()
        self.dataTimer?.stop()
    }
    
}
