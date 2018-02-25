//
//  MockTimer.swift
//  AudioProcessorPackageDescription
//
//  Created by Sam Meech-Ward on 2017-11-25.
//

@testable import AudioProcessor
import Foundation
import AudioIO

class MockTimer: TimerType {
    
    var started = false
    var stopped = false
    var block: (() -> (Void))?
    
    func tick() {
        block?()
    }
    
    func start(_ block: @escaping () -> (Void)) {
        self.block = block
        started = true
    }
    
    func stop() {
        stopped = true
    }
}
