import XCTest
import Observe
import Focus
@testable import AudioProcessor

/// Tests for the Audio Recorder Object when initialized with an AudioPowerTracker
class AudioRecorder_AudioPower_tests: XCTestCase {
    
    override class func setUp() {
        Focus.defaultReporter().failBlock = XCTFail
    }
    
    func testSpec() {
        describe("AudioRecorder") {
            
            context("when initialized with an AudioRecordable") {
                
                context("when initialized with an audio data closure") {
                    
                    var audioRecorder: AudioRecorder!
                    var mockRecordable: MockRecordable!
                    var audioSample: AudioSample?
                    var passedInRecordable: AudioRecordable?
                    beforeEach {
                        mockRecordable = MockRecordable()
                        audioRecorder = AudioRecorder(recordable: mockRecordable) { sample, recordable in
                            audioSample = sample
                            passedInRecordable = recordable
                        }
                    }
                    
                    describe("#start()") {
                        it("should pass in the recordable's initial decible power") {
                            mockRecordable.decibelPower = 0
                            audioRecorder.start()
                            expect(audioSample?.power == 0).to.be.true()
                            
                            mockRecordable.decibelPower = 1
                            audioRecorder.start()
                            expect(audioSample?.power == 1).to.be.true()
                        }
                    }
                    
                    context("when initialized with a Timer") {
                        
                        var mockTimer: MockTimer!
                        beforeEach {
                            mockTimer = MockTimer()
                            mockRecordable = MockRecordable()
                            audioRecorder = AudioRecorder(recordable: mockRecordable, dataTimer: mockTimer, dataClosure: { sample, recordable  in
                                audioSample = sample
                            })
                        }
                        
                        describe("#start()") {
                            
                            context("when the timer triggers") {
                                
                                it("should update the decible power") {
                                    mockRecordable.decibelPower = 0
                                    mockTimer.tick()
                                    expect(audioSample?.power == 0).to.be.true()
                                    
                                    mockRecordable.decibelPower = 1
                                    mockTimer.tick()
                                    expect(audioSample?.power == 1).to.be.true()
                                }
                            }
                        }
                        describe("#stop()") {
                        }
                    }
                }
            }
        }
    }
    static var allTests = [("testSpec", testSpec),]
}


