import XCTest
import Observe
import Focus
@testable import AudioProcessor

class MockRecordable: AudioRecordable {
    
    var currentTime: TimeInterval = 0
    
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

class MockTimer: TimerType {
    
    var block: (() -> (Void))?
    
    func start(_ block: @escaping () -> (Void)) {
        self.block = block
    }
    
    func stop() {
        
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
                
                    var audioSample: AudioSample?
                    beforeEach {
                        mockRecordable = MockRecordable()
                        audioRecorder = AudioRecorder(recordable: mockRecordable) { sample in
                            audioSample = sample
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
                        
                        it("should pass in the recordable's current time power") {
                            mockRecordable.currentTime = 0
                            audioRecorder.start()
                            expect(audioSample?.time == 0).to.be.true()
                            
                            mockRecordable.currentTime = 1
                            audioRecorder.start()
                            expect(audioSample?.time == 1).to.be.true()
                        }
                    }
                        
                    context("when initialized with a Timer") {
                        
//                        var audioData: (power: Float?, updateClosure: (()->(Void))?) = (nil, nil)
                        // Be able to pass in a paramter that is a closure that starts a timer but allows the recorder to pass in a function so that every time the timer, or in this case a manually triggered event, is called; it calls the f data closure with the most up to date data.
                        // self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block:self.timerUpdated)
                        beforeEach {
                            let mockTimer = MockTimer()
                            mockRecordable = MockRecordable()
                            audioRecorder = AudioRecorder(recordable: mockRecordable, dataTimer: mockTimer, dataClosure: { sample in
                                audioSample = sample
                            })
                        }
                        
                        
                        describe("#start()") {
                            it ("should start the timer") {
                                
                            }
                            
                            it ("should update the audio data every time the timer triggers") {
                                
                            }
                        }
                        
                        describe("#stop()") {
                            it ("Should stop the timer") {
                                
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    static var allTests = [("testSpec", testSpec),]
}

