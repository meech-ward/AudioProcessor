import XCTest
import Observe
import Focus
@testable import AudioIO

class MockMicrophone: MockStartAndStoppable, MicrophoneType {
  
  var bufferClosure: ((UnsafeMutablePointer<Float>, Int) -> (Void)) = { buffer, bufferLength in
    
  }
  
}

class BufferClosureHelper {
  
  var buffer :UnsafeMutablePointer<Float>?
  var bufferSize :Int?
  
  func closure(_ buffer: UnsafeMutablePointer<Float>, _ bufferSize: Int) {
    self.buffer = buffer
    self.bufferSize = bufferSize
  }
}


class AudioInputTests: XCTestCase {
  
  override class func setUp() {
    Focus.defaultReporter().failBlock = XCTFail
  }
  
  func testSpec() {
    describe("AudioInput") {
      context("when initialized with a microphone type") {
        and("a buffer closure") {
          var mockMicrophone: MockMicrophone!
          var audioInput: AudioInput!
          var bufferClosureHelper: BufferClosureHelper!
          
          beforeEach {
            bufferClosureHelper = BufferClosureHelper()
            mockMicrophone = MockMicrophone()
            audioInput = AudioInput(microphone: mockMicrophone, bufferClosure: bufferClosureHelper.closure)
          }
          
          and("an amplitude tracker") {
            var amplitudeTracker: MockAudioAmplitudeTracker!
            beforeEach {
              amplitudeTracker = MockAudioAmplitudeTracker()
              audioInput = AudioInput(microphone: mockMicrophone, bufferClosure: bufferClosureHelper.closure, amplitudeTracker: amplitudeTracker)
            }
            
            describe("#start") {
              
              beforeEach {
                audioInput.start()
              }
              
              it("should tell the amplitude tracker to start") {
                expect(amplitudeTracker.started).to.be.true()
              }
              
              context("when the amplitude is checked") {
                
              }
            }
            
            describe("#stop") {
              
              beforeEach {
                audioInput.stop()
              }
              
              it("should tell the microphone to stop") {
                expect(mockMicrophone.stopped).to.be.true()
              }
              it("should tell the amplitude tracker to stop") {
                expect(amplitudeTracker.stopped).to.be.true()
              }
            }
          }
          
          describe("#start") {
            
            beforeEach {
              audioInput.start()
            }
            
            it("should tell the microphone to start") {
              expect(mockMicrophone.started).to.be.true()
            }
            
            context("when the microphone updates its buffer") {
              
              var buffer: [Float] = [2.0]
              beforeEach {
                mockMicrophone.bufferClosure(&buffer, 2)
              }
              
              it("the audio output should update its buffer") {
                guard let firstBufferValue = bufferClosureHelper.buffer?.pointee else {
                  expect("").fail()
                  return
                }
                expect(firstBufferValue == buffer[0]).to.be.true("Expected \(String(describing: (firstBufferValue))) == \(buffer[0])")
                expect(bufferClosureHelper.bufferSize == 2).to.be.true()
              }
            }
            
          }
        }
      }
    }
  }
  
  static var allTests = [("testSpec", testSpec),]
}
