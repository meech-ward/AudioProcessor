
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
    
    /**
     sampleSecondsBeforePeak: The amount of time to sample before the peak sample. Use this to make sure the entier peice of audio doens't get sampled.
     sampleSecondsAfterPeak: Same as previous but after the peak
     peakRange: The range to test the peak for. If this number number was 0.2, then any sound with an aplitude between the biggest amplitude and 0.2 minus that amplitude will be counted for the peak position.
    */
    func processBasedOnAmplitude(sampleSecondsBeforePeak: TimeInterval? = nil, sampleSecondsAfterPeak: TimeInterval? = nil, peakRange: Double = 0.0) throws -> AudioTimeData {
        try makeSureSamplesHaveAmplitude()
        
        var start: TimeInterval = samples.first!.time
        var end: TimeInterval = samples.last!.time
        
        let biggestSample = self.largestSample()
        let smallestSample = self.smallestSample()
        
        if smallestSample.amplitude! == biggestSample.amplitude!  {
            return AudioTimeData(startTime: start, endTime: end)
        }
        
        // Peak
        let lastPeakIndex = self.intendedPeakIndex(peakRange: peakRange)//self.lastPeakIndex(peakSample: biggestSample, valleySample: smallestSample)
        
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
        for i in lastPeakIndex..<samples.count {
            let sample = samples[i]

            if (sample.amplitude! < averageAmplitudeChanges.negative)  {
                end = sample.time
                break
            }
        }
        
//        var averageChangeBetweenSamples
        // Start Time
        for i in (0..<lastPeakIndex).reversed() {
            let sample = samples[i]
            
            if (sample.amplitude! < averageAmplitudeChanges.positive)  {
                start = samples[i].time
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
    
    private func peakIndexes(peakRange: Double = 0.0) -> [Int] {
        let biggestSample = self.largestSample()
        let smallestSample = self.smallestSample()
        let peakIndex = self.lastPeakIndex(peakSample: biggestSample, valleySample: smallestSample)
        let peakAmplitude = samples[peakIndex].amplitude!
        
        var largestIndexes = [Int]()
        for (index, sample) in samples.enumerated() {
            var lastSample: AudioSample?
            var nextSample: AudioSample?
            if index > 0 {
                lastSample = samples[index-1]
            }
            if index < samples.count-1 {
                lastSample = samples[index+1]
            }
            guard let amplitude = sample.amplitude else {
                continue
            }
            
            if amplitude >= peakAmplitude-peakRange {
                
                if let lastSample = lastSample {
                    if lastSample.amplitude! > sample.amplitude! {
                        continue
                    }
                }
                
                if let nextSample = nextSample {
                    if nextSample.amplitude! > sample.amplitude! {
                        continue
                    }
                }
                
                largestIndexes.append(index)
            }
        }
        
        return largestIndexes
    }
    
    func intendedPeakIndex(peakRange: Double = 0.0) -> Int {

        var largestIndexes = peakIndexes(peakRange: peakRange)
        
        if largestIndexes.count == 1 {
            return largestIndexes[0]
        }
        
        var averageAmplitudes = [Double]()
        for index in largestIndexes {
            var averageAmplitude = 0.0
            var numberOfAmplitudes = 0
            for innerIndex in 0..<11 {
                let currentIndex = innerIndex+index-5
                if currentIndex < 0 || currentIndex >= samples.count {
                    continue
                }
                
                let sample = samples[currentIndex]
                guard let amplitude = sample.amplitude else {
                    continue
                }
                numberOfAmplitudes += 1
                averageAmplitude += amplitude
            }
            
            averageAmplitude /= Double(numberOfAmplitudes)
            averageAmplitudes.append(averageAmplitude)
        }
        
        var largestAverageAmplitude = 0.0
        var largestAmplitudeIndex = 0
        for (index, amplitude) in averageAmplitudes.enumerated() {
            if amplitude >= largestAverageAmplitude {
                largestAverageAmplitude = amplitude
                largestAmplitudeIndex = index
            }
        }
        
        
        var largestIndex = largestIndexes[largestAmplitudeIndex]
        return largestIndex
    }
}
