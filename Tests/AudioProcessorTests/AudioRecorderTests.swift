import XCTest
import Observe
import Focus
@testable import AudioProcessor

class MockRecordable: AudioRecordable {
    var started = false;
    var stopped = false;
    func start() {
        started = true;
    }
    func stop() {
        stopped = true;
    }
    func averageDecibelPower(forChannel channelNumber: Int) -> Float {
        return 0
    }
}

class AudioRecorderTests: XCTestCase {
    
    override class func setUp() {
        Focus.defaultReporter().failBlock = XCTFail
    }
    
    func testSpec() {
        describe("AudioRecorder") {
            
            context("when initialized with an AudioRecordable") {
                
                var audioRecorder: AudioRecorder!
                var mockRecordable: MockRecordable!
                beforeEach {
                    mockRecordable = MockRecordable()
                    audioRecorder = AudioRecorder(recordable: mockRecordable)
                }
                
                describe("#start()") {
                    it("should start the recordable") {
                        audioRecorder.start()
                        expect(mockRecordable.started).to.be.true()
                    }
                }
                
                describe("#stop()") {
                    it("should stop the recordable") {
                        audioRecorder.stop()
                        expect(mockRecordable.stopped).to.be.true()
                    }
                }
                
                context("and an audio data closure") {
                    
                    func dataClosure(meterLevel: Float) {
                        
                    }
                
//                beforeEach {
//                    let recordable = MockRecordable()
//                    audioRecorder = AudioRecorder(recordable: recordable, dataClosure: dataClosure)
//                }
                }
            }
            
        }
    }
    
    static var allTests = [("testSpec", testSpec),]
}

