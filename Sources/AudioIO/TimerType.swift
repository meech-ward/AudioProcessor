//
//  TimerType.swift
//  AudioProcessorPackageDescription
//
//  Created by Sam Meech-Ward on 2017-11-21.
//

import Foundation

public protocol TimerType {
    
    /// Start timing and execute the block on every time interval
    func start(_ block: @escaping () -> (Void))
    
    /// Stop timing
    func stop()
}
