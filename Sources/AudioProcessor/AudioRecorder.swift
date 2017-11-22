//
//  AudioRecorder.swift
//  AudioProcessorPackageDescription
//
//  Created by Sam Meech-Ward on 2017-11-21.
//

import Foundation

typealias AudioRecorderDataClosure = ((_ averagePower: Float) -> (Void))

public struct AudioRecorder {
    
    private let recordable: AudioRecordable
    private let dataClosure: AudioRecorderDataClosure
    
    init(recordable: AudioRecordable, dataClosure: @escaping AudioRecorderDataClosure = {_ in }) {
        self.recordable = recordable
        self.dataClosure = dataClosure
    }
    
    func start() {
        recordable.start()
        let power = recordable.averageDecibelPower(forChannel: 0)
        self.dataClosure(power)
    }
    
    func stop() {
        recordable.stop()
    }
    
}
