//
//  AudioRecorder_AudioAmplitudeTracker_tests.swift
//  AudioProcessorTests
//
//  Created by Sam Meech-Ward on 2017-11-25.
//

import XCTest
import Observe
import Focus
@testable import AudioProcessor

fileprivate class MockAudioAmplitudeTracker: AudioAmplitudeTracker {
    func setAmplitude(_ amplitude: Double) {
        self.amplitude = amplitude
    }
    var amplitude: Double?
    
    var rightAmplitude: Double?
    
    var leftAmplitude: Double?
}

/// Tests for the Audio Recorder Object when initialized with an AudioPowerTracker
class AudioRecorder_AudioAmplitudeTracker_tests: XCTestCase {
    
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
                        var mockAmplitudeTracker: MockAudioAmplitudeTracker!
                        beforeEach {
                            mockAmplitudeTracker = MockAudioAmplitudeTracker()
                            mockRecordable = MockRecordable()
                            audioRecorder = AudioRecorder(recordable: mockRecordable, amplitudeTracker: mockAmplitudeTracker) { sample, recordable in
                                audioSample = sample
                            }
                        }
                        
                        describe("#start()") {
                            
                            func itShouldPassInInitial(_ thing: String, setter: @escaping ((Double) -> (Void)), getter: @escaping (() -> (Double?))) {
                                itShouldCheckValue(thing: thing, inbetweenFunction: {audioRecorder.start()}, setter: setter, getter: getter)
                            }
                            
                            itShouldPassInInitial("amplitude", setter: mockAmplitudeTracker.setAmplitude, getter: { audioSample?.amplitude })
                            
                            itShouldPassInInitial("left amplitude", setter: { mockAmplitudeTracker.leftAmplitude = $0 }, getter: { audioSample?.leftAmplitude })
                            
                            itShouldPassInInitial("right amplitude", setter: { mockAmplitudeTracker.rightAmplitude = $0 }, getter: { audioSample?.rightAmplitude })
                        }
                        
                        context("when initialized with a Timer") {
                            
                            var mockTimer: MockTimer!
                            beforeEach {
                                mockTimer = MockTimer()
                                mockRecordable = MockRecordable()
                                mockAmplitudeTracker = MockAudioAmplitudeTracker()
                                audioRecorder = AudioRecorder(recordable: mockRecordable, amplitudeTracker: mockAmplitudeTracker, dataTimer: mockTimer, dataClosure: { sample, recordable  in
                                    audioSample = sample
                                })
                            }
                            
                            describe("#start()") {
                                
                                beforeEach {
                                    audioRecorder.start()
                                }
                                
                                context("when the timer triggers") {
                                    
                                    func itShouldUpdateThe(_ thing: String, setter: @escaping ((Double) -> (Void)), getter: @escaping (() -> (Double?))) {
                                        itShouldCheckValue(thing: thing, inbetweenFunction: mockTimer.tick, setter: setter, getter: getter)
                                    }
                                    
                                    itShouldUpdateThe("amplitude", setter: mockAmplitudeTracker.setAmplitude, getter: { audioSample?.amplitude })
                                    
                                    itShouldUpdateThe("left amplitude", setter: { mockAmplitudeTracker.leftAmplitude = $0 }, getter: { audioSample?.leftAmplitude })
                                    
                                    itShouldUpdateThe("right amplitude", setter: { mockAmplitudeTracker.rightAmplitude = $0 }, getter: { audioSample?.rightAmplitude })
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


func itShouldCheckValue(thing: String, inbetweenFunction: @escaping () -> (Void), setter: @escaping ((Double) -> (Void)), getter: @escaping (() -> (Double?))) {
    it("the sample should pass in the initial " + thing) {
        
        func testWithValue(_ expectedValue: Double) {
            setter(expectedValue)
            inbetweenFunction()
            let value = getter()
            expect(expectedValue == value).to.be.true("expected \(String(describing: value) ) to be \(expectedValue)")
        }
        
        testWithValue(0)
        testWithValue(1)
        testWithValue(2)
    }
}

