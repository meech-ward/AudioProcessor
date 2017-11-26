
import Foundation

enum AudioProcessorError: Error {
    case noData
    case noAmplitudeData
}

struct AudioProcessor {
    let samples: [AudioSample]
    
    init(samples: [AudioSample]) {
        self.samples = samples
    }
    
    func processBasedOnAmplitude() throws -> AudioTimeData {
        if samples.isEmpty {
            throw AudioProcessorError.noData
        }
        
        for sample in samples {
            guard let _ = sample.amplitude else {
                throw AudioProcessorError.noAmplitudeData
            }
        }
        
        var start: TimeInterval = samples.first!.time
        var end: TimeInterval = samples.last!.time
        
        let biggestSample = self.largestSample()
        let smallestSample = self.smallestSample()
        
        if smallestSample.amplitude! == biggestSample.amplitude!  {
            return AudioTimeData(startTime: start, endTime: end)
        }
        
        let lastPeakIndex = self.lastPeakIndex(peakSample: biggestSample, valleySample: smallestSample)
        
        // End time
        for i in lastPeakIndex..<samples.count {
            let sample = samples[i]
            guard let amplitude = sample.amplitude else {
                throw AudioProcessorError.noAmplitudeData
            }
            
            if (amplitude == smallestSample.amplitude!)  {
                end = sample.time
                break
            }
        }
        
        // Start Time
        for i in (0..<lastPeakIndex).reversed() {
            let sample = samples[i]
            guard let amplitude = sample.amplitude else {
                throw AudioProcessorError.noAmplitudeData
            }
            
            if (amplitude == smallestSample.amplitude!)  {
                start = samples[i+1].time
                break
            }
        }
        
        return AudioTimeData(startTime: start, endTime: end)
    }
}

extension AudioProcessor {
    
    private func largestSample() -> AudioSample {
        return samples.reduce(AudioSample(time: 0, amplitude: 0)) { initial, next in
            if initial.amplitude! < next.amplitude! {
                return next
            }
            return initial
        }
    }
    
    private func smallestSample() -> AudioSample {
        return samples.reduce(AudioSample(time: 0, amplitude: 0)) { initial, next in
            if initial.amplitude! > next.amplitude! {
                return next
            }
            return initial
        }
    }
    
    private func lastPeakIndex(peakSample: AudioSample, valleySample: AudioSample) -> Int {
        var inMainAudio = false
        var lastPeakIndex: Int = 0
        for (index, sample) in samples.enumerated() {
            if sample.amplitude! == peakSample.amplitude!  && inMainAudio == false {
                inMainAudio = true
                lastPeakIndex = index
            } else if (sample.amplitude! == valleySample.amplitude!) && (inMainAudio == true) {
                inMainAudio = false
            }
        }
        
        return lastPeakIndex
    }
}
