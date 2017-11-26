import XCTest
import Observe
import Focus
@testable import AudioProcessor

/// Tests for the Audio Recorder Object when initialized with an Audio Recordable
class averageAmplitudeChangeBetweenSamplesTests: XCTestCase {
    
    override class func setUp() {
        Focus.defaultReporter().failBlock = XCTFail
    }
    
    func testSpec() {
        describe("AudioProcessor") {
            describe("#averageAmplitudeChangeBetweenSamples()") {
                
                context("Positive Average") {
                    context("given no data") {
                        it("should return 0") {
                            let processor = AudioProcessor(samples: [])
                            self.expectProcessor(processor, toAveragePositiveSamplesTo: 0)
                        }
                    }
                    
                    context("given empty sample") {
                        it("should return 0") {
                            let processor = AudioProcessor(samples: [AudioSample(time: 0)])
                            self.expectProcessor(processor, toAveragePositiveSamplesTo: 0)
                        }
                    }
                    
                    context("given a sample with 1") {
                        it("should return 0") {
                            self.expectAmplitudes([1.0], toAveragePositiveSamplesTo: 0.0)
                        }
                    }
                    
                    context("given a sample with [0, 1]") {
                        it("should return 1") {
                            self.expectAmplitudes([0.0, 1.0], toAveragePositiveSamplesTo: 1.0)
                        }
                    }
                    
                    context("given a sample") {
                        it("should return average") {
                            self.expectAmplitudes([0.0, 1.0, 2.0, 3.0], toAveragePositiveSamplesTo: 1.0)
                            self.expectAmplitudes([0.0, 1.0, 1.0, 1.0, 1.0], toAveragePositiveSamplesTo: 1.0)
                            self.expectAmplitudes([0.0, 0.5, 0.0, 0.5], toAveragePositiveSamplesTo: 0.5)
                            self.expectAmplitudes([0.0, 1.0, 0.0, 1.0, 0.5, 1.5], toAveragePositiveSamplesTo: 1.0)
                        }
                    }
                }
                
                context("Negative Average") {
                    context("given no data") {
                        it("should return 0") {
                            let processor = AudioProcessor(samples: [])
                            self.expectProcessor(processor, toAverageNegativeSamplesTo: 0)
                        }
                    }

                    context("given empty sample") {
                        it("should return 0") {
                            let processor = AudioProcessor(samples: [AudioSample(time: 0)])
                            self.expectProcessor(processor, toAverageNegativeSamplesTo: 0)
                        }
                    }

                    context("given a sample with 1") {
                        it("should return 0") {
                            self.expectAmplitudes([1.0], toAverageNegativeSamplesTo: 0.0)
                        }
                    }

                    context("given a sample with [0, 1]") {
                        it("should return 1") {
                            self.expectAmplitudes([0.0, 1.0], toAverageNegativeSamplesTo: 0.0)
                        }
                    }

                    context("given a sample") {
                        it("should return average") {
                            self.expectAmplitudes([0.0, 1.0, 2.0, 3.0], toAverageNegativeSamplesTo: 0.0)
                            self.expectAmplitudes([3.0, 2.0, 1.0, 0.0], toAverageNegativeSamplesTo: 1.0)
                            self.expectAmplitudes([1.0, 1.0, 1.0, 1.0, 0.0], toAverageNegativeSamplesTo: 1.0)
                            self.expectAmplitudes([0.0, 0.5, 0.0, 0.5], toAverageNegativeSamplesTo: 0.5)
                            self.expectAmplitudes([0.0, 1.0, 0.0, 1.5, 0.5, 1.5], toAverageNegativeSamplesTo: 1.0)
//                            self.expectAmplitudes(, toAverageNegativeSamplesTo: 1.0)
//                            self.expectAmplitudes(, toAverageNegativeSamplesTo: 0.0)
                        }
                    }
                }
            }
        }
    }
     static var allTests = [("testSpec", testSpec),]
    
    func expectAmplitudes(_ amplitudes: [Double], toAveragePositiveSamplesTo value: Double) {
        let samples = SampleData.samples(fromAmplitudes: amplitudes)
        let processor = AudioProcessor(samples: samples)
        self.expectProcessor(processor, toAveragePositiveSamplesTo: value)
    }
    
    func expectAmplitudes(_ amplitudes: [Double], toAverageNegativeSamplesTo value: Double) {
        let samples = SampleData.samples(fromAmplitudes: amplitudes)
        let processor = AudioProcessor(samples: samples)
        self.expectProcessor(processor, toAverageNegativeSamplesTo: value)
    }
    
    func expectProcessor(_ processor: AudioProcessor, toAveragePositiveSamplesTo value: Double) {
        let average = processor.averageAmplitudeChangeBetweenSamples()
        expect(average.positive == value).to.be.true("expected average positive to be \(value) instead of \(average.positive)")
    }
    
    func expectProcessor(_ processor: AudioProcessor, toAverageNegativeSamplesTo value: Double) {
        let average = processor.averageAmplitudeChangeBetweenSamples()
        expect(average.negative == value).to.be.true("expected average negative to be \(value) instead of \(average.positive)")
    }
}
