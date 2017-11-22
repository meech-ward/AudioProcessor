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
    
    init(recordable: AudioRecordable, dataTimer: TimerType? = nil, dataClosure: @escaping AudioRecorderDataClosure = {_ in }) {
        self.recordable = recordable
        self.dataClosure = dataClosure
    }
    
    func start() {
        recordable.start()
        let power = recordable.averageDecibelPower(forChannel: 0)
        let time = recordable.currentTime
        let sample = AudioSample(time: time, power: power)
        self.dataClosure(sample)
    }
    
    func stop() {
        recordable.stop()
    }
    
}
