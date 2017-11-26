
enum AudioProcessorError: Error {
    case noData
    case noAmplitudeData
}

struct AudioProcessor {
    let samples: [AudioSample]
    
    init(samples: [AudioSample]) {
        self.samples = samples
    }
    
    func processBasedOnAmplitude() throws {
        for sample in samples {
            guard let amplitude = sample.amplitude else {
                throw AudioProcessorError.noAmplitudeData
            }
        }
        throw AudioProcessorError.noData
    }
}
