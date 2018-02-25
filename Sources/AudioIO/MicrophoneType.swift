//
//  MicrophoneType.swift
//  AudioIOPackageDescription
//
//  Created by Sam Meech-Ward on 2018-01-12.
//

import Foundation

public protocol MicrophoneType: class {
  var bufferClosure: ((UnsafeMutablePointer<Float>, Int) -> (Void)) { get set }
}
