import XCTest
import Observe
import Focus
@testable import AudioProcessor

/// Tests for the Audio Recorder Object when initialized with an Audio Recordable
class AudioProcessor_ProcessBasedOnAmplitude_tests: XCTestCase {
    
    override class func setUp() {
        Focus.defaultReporter().failBlock = XCTFail
    }
    
    func testSpec() {
        describe("AudioProcessor") {
            describe("#processBasedOnAmplitude()") {
                context("given no data") {
                    it("should throw an error") {
                        let processor = AudioProcessor(samples: SampleData.noData())
                        var error: AudioProcessorError?
                        do {
                            try processor.processBasedOnAmplitude()
                        } catch let e {
                            error = e as? AudioProcessorError
                        }
                        expect(error != nil).to.be.true()
                        expect(error == AudioProcessorError.noData).to.be.true()
                    }
                }
                
                context("given sample with no amplitude") {
                    it("should throw an error") {
                        let processor = AudioProcessor(samples: SampleData.oneSampleInvalidSample())
                        var error: AudioProcessorError?
                        do {
                            try processor.processBasedOnAmplitude()
                        } catch let e {
                            error = e as? AudioProcessorError
                        }
                        expect(error != nil).to.be.true()
                        expect(error == AudioProcessorError.noAmplitudeData).to.be.true()
                    }
                }
                
                context("given single sample with 0 amplitude") {
                    it("should return start and end time as the sample time") {
                        let samples = SampleData.oneSampleValidSample()
                        let processor = AudioProcessor(samples: samples)
                        let timeData = try? processor.processBasedOnAmplitude()
                        expect(timeData?.startTime == samples[0].time).to.be.true()
                        expect(timeData?.endTime == samples[0].time).to.be.true()
                    }
                }
                
                context("given 2 samples with 0 amplitude") {
                    it("should return start time of the first sample and end time of the second sample") {
                        let samples = SampleData.twoSampleValidSample()
                        let processor = AudioProcessor(samples: samples)
                        let timeData = try? processor.processBasedOnAmplitude()
                        expect(timeData?.startTime == samples[0].time).to.be.true()
                        expect(timeData?.endTime == samples[1].time).to.be.true()
                    }
                }
                
                
                context("given many samples with 0 amplitude") {
                    it("should return start time of the first sample and end time of the last sample") {
                        let amplitudes = [0.0, 0, 0, 0, 0]
                        let samples = SampleData.samples(fromAmplitudes: amplitudes)
                        self.expectSamples(samples, toHaveStartTime: samples[0].time, andEndTime: samples.last!.time)
                    }
                }
                
                context("given some samples with 0 amplitude and an amplitude of 1 in the middle") {
                    it("should return start time of the 1 sample and end time of the 0 after that sample") {
                        let samples = SampleData.some0SamplesWith1InTheMiddle()
                        let processor = AudioProcessor(samples: samples)
                        let timeData = try? processor.processBasedOnAmplitude()
                        expect(timeData?.startTime == samples[2].time).to.be.true()
                        expect(timeData?.endTime == samples[3].time).to.be.true()
                    }
                }
                
                context("given some samples with 0 amplitude and some amplitudes of 1 together in the middle") {
                    it("should return start time of the 1st 1 sample and end time of the 0 after all the one samples") {
                        let samples = SampleData.some0SamplesWith1sInTheMiddle()
                        let processor = AudioProcessor(samples: samples)
                        let timeData = try? processor.processBasedOnAmplitude()
                        expect(timeData?.startTime == samples[2].time).to.be.true()
                        expect(timeData?.endTime == samples[5].time).to.be.true()
                    }
                }
                
                context("given some samples that go [0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0]") {
                    it("should return start time of the 1st 1 sample in the second group and end time of the 0 after all the one samples") {
                        let samples = SampleData.some0SamplesWith1sInTheMiddleAndEnd()
                        let processor = AudioProcessor(samples: samples)
                        let timeData = try? processor.processBasedOnAmplitude()
                        expect(timeData?.startTime == samples[7].time).to.be.true()
                        expect(timeData?.endTime == samples[10].time).to.be.true()
                    }
                }
                
                
                
                context("given some samples that go [0, 0,0, 0,0, 0,0, 0,0, 0, 0.5, 1, 1, 1, 0.75, 0.5, 0.25 0, 0]") {
                    it("should return a good start and end time") {
                        let amplitudes = [0, 0,0, 0,0, 0,0, 0,0, 0, 0.25, 0.5, 1, 1, 1, 0.75, 0.5, 0.25, 0, 0]
                        let samples = SampleData.samples(fromAmplitudes: amplitudes)
                        self.expectSamples(samples, toHaveStartTime: samples[10].time, andEndTime: samples[18].time)
                    }
                }
                
                context("given some samples that go [0, 0,0, 0,0, 0,0, 0,0, 0, 0.25, 0.5, 1, 1, 1, 0.75, 0.5, 0.25, 0, 0, 0.25, 0.5, 1, 1, 1, 0.75, 0.5, 0.25, 0, 0]") {
                    it("should same as last but second peak") {
                        let amplitudes = [0, 0,0, 0,0, 0,0, 0,0, 0, 0.25, 0.5, 1, 1, 1, 0.75, 0.5, 0.25, 0, 0, 0.25, 0.5, 1, 1, 1, 0.75, 0.5, 0.25, 0, 0]
                        let samples = SampleData.samples(fromAmplitudes: amplitudes)
                        self.expectSamples(samples, toHaveStartTime: samples[20].time, andEndTime: samples[28].time)
                    }
                }
                
                context("given some samples") {
                    it("should") {
                        let amplitudes = [0, 0.1, 0.05, 0.15, 0.05, 0.5, 1, 1, 1, 0.75, 0.5, 0.25, 0, 0]
                        let samples = SampleData.samples(fromAmplitudes: amplitudes)
                        self.expectSamples(samples, toHaveStartTime: samples[5].time, andEndTime: samples[12].time)
                    }
                }
            }
        }
    }
    static var allTests = [("testSpec", testSpec),]
    
    func expectSamples(_ samples: [AudioSample], toHaveStartTime start: TimeInterval, andEndTime end: TimeInterval) {
        let processor = AudioProcessor(samples: samples)
        let timeData = try? processor.processBasedOnAmplitude()
        let expectStartRange = timeData?.startTime == start || timeData?.startTime == start-1 || timeData?.startTime == start+1
        let expectEndRange = timeData?.endTime == end || timeData?.endTime == end-1 || timeData?.endTime == end+1
        expect(expectStartRange).to.be.true("expecting \(start) but instead got \(String(describing: timeData?.startTime))")
        expect(expectEndRange).to.be.true("expecting \(end) but instead got \(String(describing: timeData?.endTime))")
    }
}


