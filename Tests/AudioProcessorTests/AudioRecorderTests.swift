import XCTest
import Observe
import Focus
@testable import AudioProcessor

class MockRecordable: AudioRecordable {
    var started = false;
    var stopped = false;
    var decibelPower: Float = 0;
    
    func start() {
        started = true;
    }
    func stop() {
        stopped = true;
    }
    func averageDecibelPower(forChannel channelNumber: Int) -> Float {
        if (channelNumber == 0) {
            return decibelPower
        }
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
                
                context("when initialized with an audio data closure") {
                
                    var audioData: (power: Float?, data: Any?) = (nil, nil)
                    beforeEach {
                        mockRecordable = MockRecordable()
                        audioRecorder = AudioRecorder(recordable: mockRecordable) { power in
                            audioData.power = power
                        }
                    }
                    
                    describe("#start()") {
                        it("should pass in the recordable's initial decible power") {
                            mockRecordable.decibelPower = 0
                            audioRecorder.start()
                            expect(audioData.power == 0).to.be.true()
                            
                            mockRecordable.decibelPower = 1
                            audioRecorder.start()
                            expect(audioData.power == 1).to.be.true()
                        }
                        
                        it("should pass in the recordable's decible power approximately every 0.1 seconds") {
                            mockRecordable.decibelPower = 0
                            audioRecorder.start()
                            expect(audioData.power == 0).to.be.true()
                            
                            mockRecordable.decibelPower = 1
                            audioRecorder.start()
                            expect(audioData.power == 1).to.be.true()
                        }
                        
                    }
                }
            }
            
        }
    }
    
    static var allTests = [("testSpec", testSpec),]
}

