//
//  MockRecordable.swift
//  AudioProcessorTests
//
//  Created by Sam Meech-Ward on 2017-11-25.
//

@testable import AudioProcessor
import Foundation

class MockRecordable: AudioRecordable {
    
    var currentTime: TimeInterval = 0
    
    var started = false
    var stopped = false
    
    func start() {
        started = true
    }
    func stop() {
        stopped = true
    }
}
