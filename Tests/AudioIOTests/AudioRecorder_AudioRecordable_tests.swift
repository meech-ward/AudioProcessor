import XCTest
import Observe
import Focus
@testable import AudioIO

/// Tests for the Audio Recorder Object when initialized with an Audio Recordable
class AudioRecorder_AudioRecordable_Tests: XCTestCase {
    
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
              
              describe(".isRecording") {
                
                it("should return the current state of the recordable") {
                  mockRecordable.isRecording = false
                  expect(audioRecorder.isRecording == false).to.be.true()
                  
                  mockRecordable.isRecording = true
                  expect(audioRecorder.isRecording == true).to.be.true()
                }
              }
                
                context("when initialized with an audio data closure") {
                    
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
                        
                        it("should pass in the recordable's current time") {
                            mockRecordable.currentTime = 0
                            audioRecorder.start()
                            expect(audioSample?.time == 0).to.be.true()
                            
                            mockRecordable.currentTime = 1
                            audioRecorder.start()
                            expect(audioSample?.time == 1).to.be.true()
                        }
                        
                        it("should pass in the recordable object") {
                            guard let passedInRecordable = passedInRecordable as? MockRecordable else {
                                expect("").to.fail("passedInRecordable is nil")
                                return
                            }
                            expect(mockRecordable === passedInRecordable).to.be.true()
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
                            
                            beforeEach {
                                audioRecorder.start()
                            }
                            
                            it ("should start the timer") {
                                expect(mockTimer.started).to.be.true()
                            }
                            
                            context("when the timer triggers") {
                                
                                it("should update the current time") {
                                    mockRecordable.currentTime = 0
                                    mockTimer.tick()
                                    expect(audioSample?.time == 0).to.be.true()
                                    
                                    mockRecordable.currentTime = 1
                                    mockTimer.tick()
                                    expect(audioSample?.time == 1).to.be.true()
                                }
                            }
                        }
                        
                        describe("#stop()") {
                            
                            beforeEach {
                                audioRecorder.stop()
                            }
                            
                            it ("Should stop the timer") {
                                expect(mockTimer.stopped).to.be.true()
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    static var allTests = [("testSpec", testSpec),]
}


