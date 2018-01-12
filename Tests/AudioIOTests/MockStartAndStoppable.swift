//
//  MockStartAndStoppable.swift
//  AudioIOTests
//
//  Created by Sam Meech-Ward on 2018-01-12.
//

@testable import AudioIO

class MockStartAndStoppable: StartAndStopable {
  
  var started = false
  var stopped = false
  
  func start() {
    started = true
  }
  
  func stop() {
    stopped = true
  }
}
