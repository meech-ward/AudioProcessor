import XCTest
import Observe
import Focus
import AudioIO

@testable import AudioProcessor

/// Tests for the Audio Recorder Object when initialized with an Audio Recordable
class GetIntendedPeakTests: XCTestCase {
    
    override class func setUp() {
        Focus.defaultReporter().failBlock = XCTFail
    }
    
    func testSpec() {
        describe("AudioProcessor") {
            describe("#getIntendedPeakTests()") {
                context("given samples") {
                    it("should return intended peak") {
                        self.expectIndededPeakIndex(0, fromAmplitudes: [0])
                        self.expectIndededPeakIndex(1, fromAmplitudes: [0, 1, 0])
                    }
                    it("should return the second peak") {
                        self.expectIndededPeakIndex(3, fromAmplitudes: [0, 1, 0, 1, 0])
                    }
                    
                    it("should return the stronger peak") {
                        self.expectIndededPeakIndex(2, fromAmplitudes: [0, 0.9,1,0.9,0, 0,0,0,0, 1, 0])
                        self.expectIndededPeakIndex(10, fromAmplitudes: [0, 0.9,1,0.9, 0,0,0,0,0, 0.9, 1, 0.9, 0])
                        self.expectIndededPeakIndex(2, fromAmplitudes: [0, 0.95,1,0.95, 0,0,0,0,0,0, 0.9, 1, 0.9, 0])
                        self.expectIndededPeakIndex(3, fromAmplitudes: [0, 0.85, 0.9,1,0.9, 0,0,0,0,0,0, 0.9, 1, 0.9, 0])
                    }
                    
                    it("should return the stronger peak within exact range") {
                        self.expectIndededPeakIndex(3, fromAmplitudes: [0, 0.85, 0.9,0.95,0.9,0.85, 0,0,0,0,0,0, 0.9, 1, 0.9, 0], withinRange: 0.05)
                    }
                    
                    it("should return the stronger peak within non exact range") {
                        self.expectIndededPeakIndex(3, fromAmplitudes: [0, 0.85, 0.9,0.95,0.9,0.85, 0,0,0,0,0,0, 0.9, 1, 0.9, 0], withinRange: 0.1)
                    }
                }
            }
        }
    }
    
    func expectIndededPeakIndex(_ index: Int, fromAmplitudes amplitudes: [Double], withinRange: Double = 0) {
        let samples = SampleData.samples(fromAmplitudes: amplitudes)
        let processor = AudioProcessor(samples: samples)
        let intendedPeak = processor.intendedPeakIndex(peakRange: withinRange)
        expect(intendedPeak == index).to.be.true("expected: \(index), actual: \(intendedPeak)")
    }
}
