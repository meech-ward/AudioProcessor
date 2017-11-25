import XCTest
import Observe
import Focus
@testable import AudioProcessor

class MockAudioPowerTracker: AudioPowerTracker {
    
    var decibelPower: Float = 0;
    
    func averageDecibelPower(forChannel channelNumber: Int) -> Float {
        return decibelPower
    }
    
    
}

/// Tests for the Audio Recorder Object when initialized with an AudioPowerTracker
class AudioRecorder_AudioPower_tests: XCTestCase {
    
    override class func setUp() {
        Focus.defaultReporter().failBlock = XCTFail
    }
    
    func testSpec() {
        describe("AudioRecorder") {
            
            context("when initialized with an AudioRecordable") {
                
                context("when initialized with an AudioPowerTracker") {
                    
                context("when initialized with an audio data closure") {
                    
                    var audioRecorder: AudioRecorder!
                    var mockRecordable: MockRecordable!
                    var audioSample: AudioSample?
                    var mockPowerTracker: MockAudioPowerTracker!
                    beforeEach {
                        mockPowerTracker = MockAudioPowerTracker()
                        mockRecordable = MockRecordable()
                        audioRecorder = AudioRecorder(recordable: mockRecordable, powerTracker: mockPowerTracker) { sample, recordable in
                            audioSample = sample
                        }
                    }
                    
                    describe("#start()") {
                        
                        
                        
                        it("should pass in the recordable's initial decible power") {
                            mockPowerTracker.decibelPower = 0
                            audioRecorder.start()
                            expect(audioSample?.power == 0).to.be.true()
                            
                            mockPowerTracker.decibelPower = 1
                            audioRecorder.start()
                            expect(audioSample?.power == 1).to.be.true()
                        }
                    }
                    
                    context("when initialized with a Timer") {
                        
                        var mockTimer: MockTimer!
                        beforeEach {
                            mockTimer = MockTimer()
                            mockRecordable = MockRecordable()
                            mockPowerTracker = MockAudioPowerTracker()
                            audioRecorder = AudioRecorder(recordable: mockRecordable, powerTracker: mockPowerTracker, dataTimer: mockTimer, dataClosure: { sample, recordable  in
                                audioSample = sample
                            })
                        }
                        
                        describe("#start()") {
                            
                            beforeEach {
                                audioRecorder.start()
                            }
                            
                            context("when the timer triggers") {
                                
                                it("should update the decible power") {
                                    mockPowerTracker.decibelPower = 0
                                    mockTimer.tick()
                                    expect(audioSample?.power == 0).to.be.true("\(String(describing: audioSample?.power)) was expected to be \(0)")
                                    
                                    mockPowerTracker.decibelPower = 1
                                    mockTimer.tick()
                                    expect(audioSample?.power == 1).to.be.true()
                                }
                            }
                        }
                        describe("#stop()") {
                            
                            beforeEach {
                                audioRecorder.stop()
                            }
                        }
                    }
                }
                }
            }
        }
    }
    static var allTests = [("testSpec", testSpec),]
}


