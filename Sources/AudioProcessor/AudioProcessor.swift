
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
    
    private func makeSureSamplesHaveAmplitude() throws {
        if samples.isEmpty {
            throw AudioProcessorError.noData
        }
        
        for sample in samples {
            guard let _ = sample.amplitude else {
                throw AudioProcessorError.noAmplitudeData
            }
        }
    }
    
    func processBasedOnAmplitude(sampleSecondsBeforePeak: TimeInterval? = nil, sampleSecondsAfterPeak: TimeInterval? = nil) throws -> AudioTimeData {
        try makeSureSamplesHaveAmplitude()
        
        var start: TimeInterval = samples.first!.time
        var end: TimeInterval = samples.last!.time
        
        let biggestSample = self.largestSample()
        let smallestSample = self.smallestSample()
        
        if smallestSample.amplitude! == biggestSample.amplitude!  {
            return AudioTimeData(startTime: start, endTime: end)
        }
        
        // Peak
        let lastPeakIndex = self.lastPeakIndex(peakSample: biggestSample, valleySample: smallestSample)
        
        var startSampleIndex = 0
        var endSampleIndex = samples.count - 1
        
        // Before Peak
        if let seconds = sampleSecondsBeforePeak {
            let peakSeconds = samples[lastPeakIndex].time
            let secondsToStartAt = peakSeconds - seconds
            
            if secondsToStartAt > 0 {
                for (index, sample) in samples.enumerated() {
                    if sample.time > secondsToStartAt {
                        startSampleIndex = max(0, index-1)
                        break
                    }
                }
            }
        }
        
        // After Peak
        if let seconds = sampleSecondsAfterPeak {
            let peakSeconds = samples[lastPeakIndex].time
            let secondsToEndAt = peakSeconds + seconds
            
            if secondsToEndAt < samples.last!.time {
                for (index, sample) in samples.enumerated().reversed() {
                    if sample.time < secondsToEndAt {
                        endSampleIndex = min(samples.count-1, index+1)
                        break
                    }
                }
            }
        }
        
        // IF there's no significant noise
        let averageAmapliutes = self.averageAmplitudes(startSampleIndex: startSampleIndex, endSampleIndex: endSampleIndex)
        if averageAmapliutes*2 > biggestSample.amplitude! {
            return AudioTimeData(startTime: start, endTime: end)
        }
        
        let averageAmplitudeChanges = self.averageAmplitudeChangeBetweenSamples(startIndex: startSampleIndex, endIndex: endSampleIndex)
        
        // End time
        for i in lastPeakIndex...endSampleIndex {
            let sample = samples[i]

            if (sample.amplitude! < averageAmplitudeChanges.negative)  {
                end = sample.time
                break
            }
        }
        
//        var averageChangeBetweenSamples
        // Start Time
        for i in (startSampleIndex-1..<lastPeakIndex).reversed() {
            let sample = samples[i]
            
            if (sample.amplitude! < averageAmplitudeChanges.positive)  {
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
    
    private func averageAmplitudes(startSampleIndex: Int? = nil, endSampleIndex: Int? = nil) -> Double {
        let startIndex = startSampleIndex ?? 0
        let endIndex = endSampleIndex ?? samples.count-1
        
        var totalAmplitudes = 0.0
        for index in startIndex...endIndex {
            let sample = samples[index]
            totalAmplitudes += sample.amplitude!
        }
        return totalAmplitudes/Double(samples.count)
    }
    
    func averageAmplitudeChangeBetweenSamples(startIndex si: Int? = nil, endIndex ei: Int? = nil) -> (positive: Double, negative: Double) {
        if samples.count == 0 {
            return (0, 0)
        }
        
        let startIndex = si == nil ? 0 : si!
        let endIndex = ei == nil ? samples.count-1 : ei!
        
        var totalNegativeChanges = 0
        var totalNegativeAmplitudeChange = 0.0
        var totalPositiveChanges = 0
        var totalPositiveAmplitudeChange = 0.0
        for index in startIndex...endIndex {
            if (index == startIndex) {
                continue
            }
            
            guard let currentAmplitude = samples[index].amplitude else {
                continue
            }
            guard let lastAmplitude = samples[index-1].amplitude else {
                continue
            }
            
            let difference = currentAmplitude - lastAmplitude
            
            if difference < 0 {
                totalNegativeChanges += 1
                totalNegativeAmplitudeChange += (difference*(-1))
            } else if difference > 0 {
                totalPositiveChanges += 1
                totalPositiveAmplitudeChange += difference
            }
            
        }
        
        var positiveAverage: Double
        if Double(totalPositiveChanges) == 0 {
            positiveAverage = 0
        } else {
           positiveAverage = totalPositiveAmplitudeChange/Double(totalPositiveChanges)
        }
        
        var negativeAverage: Double
        if Double(totalNegativeChanges) == 0 {
            negativeAverage = 0
        } else {
            negativeAverage = totalNegativeAmplitudeChange/Double(totalNegativeChanges)
        }
        return (positiveAverage, negativeAverage)
    }
}
