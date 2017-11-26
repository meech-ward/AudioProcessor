import XCTest
import Observe
import Focus
@testable import AudioProcessor

/// Tests for the Audio Recorder Object when initialized with an Audio Recordable
class AudioProcessorUtilityTests: XCTestCase {
    
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
                            let amplitudes = [1.0]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAveragePositiveSamplesTo: 0)
                        }
                    }
                    
                    context("given a sample with [0, 1]") {
                        it("should return 1") {
                            let amplitudes = [0.0, 1.0]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAveragePositiveSamplesTo: 1)
                        }
                    }
                    
                    context("given a sample with [0, 1, 2, 3]") {
                        it("should return 1") {
                            let amplitudes = [0.0, 1.0, 2.0, 3.0]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAveragePositiveSamplesTo: 1)
                        }
                    }
                    
                    context("given a sample") {
                        it("should return average") {
                            let amplitudes = [0.0, 1.0, 1.0, 1.0, 1.0]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAveragePositiveSamplesTo: 1.0)
                        }
                    }
                    
                    context("given a sample") {
                        it("should return average") {
                            let amplitudes = [0.0, 0.5, 0.0, 0.5]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAveragePositiveSamplesTo: 0.5)
                        }
                    }
                    
                    context("given a sample") {
                        it("should return average") {
                            let amplitudes = [0.0, 1.0, 0.0, 1.0, 0.5, 1.5]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAveragePositiveSamplesTo: 1.0)
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
                            let amplitudes = [1.0]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAverageNegativeSamplesTo: 0)
                        }
                    }

                    context("given a sample with [0, 1]") {
                        it("should return 1") {
                            let amplitudes = [0.0, 1.0]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAverageNegativeSamplesTo: 0)
                        }
                    }

                    context("given a sample with [0, 1, 2, 3]") {
                        it("should return 1") {
                            let amplitudes = [0.0, 1.0, 2.0, 3.0]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAverageNegativeSamplesTo: 0)
                        }
                    }

                    context("given a sample with [3, 2, 1, 0]") {
                        it("should return 1") {
                            let amplitudes = [3.0, 2.0, 1.0, 0.0]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAverageNegativeSamplesTo: 1)
                        }
                    }

                    context("given a sample") {
                        it("should return average") {
                            let amplitudes = [1.0, 1.0, 1.0, 1.0, 0.0]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAverageNegativeSamplesTo: 1.0)
                        }
                    }


                    context("given a sample") {
                        it("should return average") {
                            let amplitudes = [0.0, 0.5, 0.0, 0.5]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAverageNegativeSamplesTo: 0.5)
                        }
                    }

                    context("given a sample") {
                        it("should return average") {
                            let amplitudes = [0.0, 1.0, 0.0, 1.5, 0.5, 1.5]
                            let samples = SampleData.samples(fromAmplitudes: amplitudes)
                            let processor = AudioProcessor(samples: samples)
                            self.expectProcessor(processor, toAverageNegativeSamplesTo: 1.0)
                        }
                    }
                }
            }
        }
    }
     static var allTests = [("testSpec", testSpec),]
    
    func expectProcessor(_ processor: AudioProcessor, toAveragePositiveSamplesTo value: Double) {
        let average = processor.averageAmplitudeChangeBetweenSamples()
        expect(average.positive == value).to.be.true("expected average positive to be \(value) instead of \(average.positive)")
    }
    
    func expectProcessor(_ processor: AudioProcessor, toAverageNegativeSamplesTo value: Double) {
        let average = processor.averageAmplitudeChangeBetweenSamples()
        expect(average.negative == value).to.be.true("expected average negative to be \(value) instead of \(average.positive)")
    }
}
