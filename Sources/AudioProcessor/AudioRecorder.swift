//
//  AudioRecorder.swift
//  AudioProcessorPackageDescription
//
//  Created by Sam Meech-Ward on 2017-11-21.
//

import Foundation

struct AudioRecorder {
    
    let recordable: AudioRecordable
    
    init(recordable: AudioRecordable, dataClosure: ((_ meterLevel: Float) -> (Void)) = {_ in }) {
        self.recordable = recordable
    }
    
    func start() {
        recordable.start()
    }
    
    func stop() {
        recordable.stop()
    }
    
}
