//
//  MockRecordable.swift
//  AudioProcessorTests
//
//  Created by Sam Meech-Ward on 2017-11-25.
//

@testable import AudioProcessor
import Foundation
import AudioIO

class MockRecordable: AudioRecordable {
  func delete(closure: @escaping ((Bool) -> ())) {
    
  }
  
  var isRecording: Bool = false
  
    
    var currentTime: TimeInterval = 0
    var startClosure: ((Bool) -> ())?
    var stopClosure: ((Bool) -> ())?
    
    var started = false
    var stopped = false
    
    func start(closure: @escaping ((Bool) -> ()) = {_ in }) {
        started = true
        startClosure = closure
    }
    func stop(closure: @escaping ((Bool) -> ()) = {_ in }) {
        stopped = true
        stopClosure = closure
    }
}
