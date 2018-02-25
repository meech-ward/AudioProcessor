import XCTest
import Observe
import Focus
@testable import AudioIO

fileprivate class MockAudioFrequencyTracker: AudioFrequencyTracker {
    var frequency: Double?
}

/// Tests for the Audio Recorder Object when initialized with an AudioPowerTracker
class AudioRecorder_AudioFrequencyTracker_tests: XCTestCase {
    
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
                        var mockFrequencyTracker: MockAudioFrequencyTracker!
                        beforeEach {
                            mockFrequencyTracker = MockAudioFrequencyTracker()
                            mockRecordable = MockRecordable()
                            audioRecorder = AudioRecorder(recordable: mockRecordable, frequencyTracker: mockFrequencyTracker) { sample, recordable in
                                audioSample = sample
                            }
                        }
                        
                        describe("#start()") {
                            
                            
                            
                            it("should pass in the recordable's initial frequency") {
                                mockFrequencyTracker.frequency = 0
                                audioRecorder.start()
                                expect(audioSample?.frequency == 0).to.be.true()
                                
                                mockFrequencyTracker.frequency = 1
                                audioRecorder.start()
                                expect(audioSample?.frequency == 1).to.be.true()
                            }
                        }
                        
                        context("when initialized with a Timer") {
                            
                            var mockTimer: MockTimer!
                            beforeEach {
                                mockTimer = MockTimer()
                                mockRecordable = MockRecordable()
                                mockFrequencyTracker = MockAudioFrequencyTracker()
                                audioRecorder = AudioRecorder(recordable: mockRecordable, frequencyTracker: mockFrequencyTracker, dataTimer: mockTimer, dataClosure: { sample, recordable  in
                                    audioSample = sample
                                })
                            }
                            
                            describe("#start()") {
                                
                                beforeEach {
                                    audioRecorder.start()
                                }
                                
                                context("when the timer triggers") {
                                    
                                    it("should update the frequency power") {
                                        mockFrequencyTracker.frequency = 0
                                        mockTimer.tick()
                                        expect(audioSample?.frequency == 0).to.be.true("\(String(describing: audioSample?.frequency)) was expected to be \(0)")
                                        
                                        mockFrequencyTracker.frequency = 1
                                        mockTimer.tick()
                                        expect(audioSample?.frequency == 1).to.be.true()
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



