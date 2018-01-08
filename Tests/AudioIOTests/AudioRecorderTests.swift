//import XCTest
//import Observe
//import Focus
//@testable import AudioProcessor
//
//fileprivate class MockRecordable: AudioRecordable {
//
//    var currentTime: TimeInterval = 0
//
//    var started = false
//    var stopped = false
//    var decibelPower: Float = 0;
//
//    func start() {
//        started = true
//    }
//    func stop() {
//        stopped = true
//    }
//    func averageDecibelPower(forChannel channelNumber: Int) -> Float {
//        if (channelNumber == 0) {
//            return decibelPower
//        }
//        return 0
//    }
//
//}
//
//fileprivate class MockTimer: TimerType {
//
//    var started = false
//    var stopped = false
//    var block: (() -> (Void))?
//
//    func tick() {
//        block?()
//    }
//
//    func start(_ block: @escaping () -> (Void)) {
//        self.block = block
//        started = true
//    }
//
//    func stop() {
//        stopped = true
//    }
//}
//
//class AudioRecorderTests: XCTestCase {
//
//    override class func setUp() {
//        Focus.defaultReporter().failBlock = XCTFail
//    }
//
//    func testSpec() {
//        describe("AudioRecorder") {
//
//            context("when initialized with an AudioRecordable") {
//
//                var audioRecorder: AudioRecorder!
//                var mockRecordable: MockRecordable!
//                beforeEach {
//                    mockRecordable = MockRecordable()
//                    audioRecorder = AudioRecorder(recordable: mockRecordable)
//                }
//
//                describe("#start()") {
//                    it("should start the recordable") {
//                        audioRecorder.start()
//                        expect(mockRecordable.started).to.be.true()
//                    }
//                }
//
//                describe("#stop()") {
//                    it("should stop the recordable") {
//                        audioRecorder.stop()
//                        expect(mockRecordable.stopped).to.be.true()
//                    }
//                }
//
//                context("when initialized with an audio data closure") {
//
//                    var audioSample: AudioSample?
//                    var passedInRecordable: AudioRecordable?
//                    beforeEach {
//                        mockRecordable = MockRecordable()
//                        audioRecorder = AudioRecorder(recordable: mockRecordable) { sample, recordable in
//                            audioSample = sample
//                            passedInRecordable = recordable
//                        }
//                    }
//
//                    describe("#start()") {
//                        it("should pass in the recordable's initial decible power") {
//                            mockRecordable.decibelPower = 0
//                            audioRecorder.start()
//                            expect(audioSample?.power == 0).to.be.true()
//
//                            mockRecordable.decibelPower = 1
//                            audioRecorder.start()
//                            expect(audioSample?.power == 1).to.be.true()
//                        }
//
//                        it("should pass in the recordable's current time") {
//                            mockRecordable.currentTime = 0
//                            audioRecorder.start()
//                            expect(audioSample?.time == 0).to.be.true()
//
//                            mockRecordable.currentTime = 1
//                            audioRecorder.start()
//                            expect(audioSample?.time == 1).to.be.true()
//                        }
//
//                        it("should pass in the recordable object") {
//                            guard let passedInRecordable = passedInRecordable as? MockRecordable else {
//                                expect("").to.fail("passedInRecordable is nil")
//                                return
//                            }
//                            expect(mockRecordable === passedInRecordable).to.be.true()
//                        }
//                    }
//
//                    context("when initialized with a Timer") {
//
////                        var audioData: (power: Float?, updateClosure: (()->(Void))?) = (nil, nil)
//                        // Be able to pass in a paramter that is a closure that starts a timer but allows the recorder to pass in a function so that every time the timer, or in this case a manually triggered event, is called; it calls the f data closure with the most up to date data.
//                        // self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block:self.timerUpdated)
//                        var mockTimer: MockTimer!
//                        beforeEach {
//                            mockTimer = MockTimer()
//                            mockRecordable = MockRecordable()
//                            audioRecorder = AudioRecorder(recordable: mockRecordable, dataTimer: mockTimer, dataClosure: { sample, recordable  in
//                                audioSample = sample
//                            })
//                        }
//
//
//                        describe("#start()") {
//                            it ("should start the timer") {
//                                audioRecorder.start()
//                                expect(mockTimer.started).to.be.true()
//                            }
//
//                            context("when the timer triggers") {
//
//                                it("should update the decible power") {
//                                    mockRecordable.decibelPower = 0
//                                    mockTimer.tick()
//                                    expect(audioSample?.power == 0).to.be.true()
//
//                                    mockRecordable.decibelPower = 1
//                                    mockTimer.tick()
//                                    expect(audioSample?.power == 1).to.be.true()
//                                }
//
//                                it("should update the current time") {
//                                    mockRecordable.currentTime = 0
//                                    mockTimer.tick()
//                                    expect(audioSample?.time == 0).to.be.true()
//
//                                    mockRecordable.currentTime = 1
//                                    mockTimer.tick()
//                                    expect(audioSample?.time == 1).to.be.true()
//                                }
//                            }
//                        }
//
//                        describe("#stop()") {
//                            it ("Should stop the timer") {
//                                audioRecorder.stop()
//                                expect(mockTimer.stopped).to.be.true()
//                            }
//                        }
//                    }
//                }
//            }
//
//        }
//    }
//
//    static var allTests = [("testSpec", testSpec),]
//}
//
