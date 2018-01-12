import XCTest
import Observe
import Focus
@testable import AudioIO

class MockMicrophone: MicrophoneType {
  
}

class AudioInputTests: XCTestCase {
  
  override class func setUp() {
    Focus.defaultReporter().failBlock = XCTFail
  }
  
  func testSpec() {
    describe("AudioInput") {
      context("when initialized with a microphone type") {
        
        var mockMicrophone: MockMicrophone!
        var audioInput: AudioInput!
        beforeEach {
          mockMicrophone = MockMicrophone()
          audioInput = AudioInput(microphone: mockMicrophone)
        }
      }
    }
  }
  
  static var allTests = [("testSpec", testSpec),]
}
