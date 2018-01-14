# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) 
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added

### Changed

## [0.1.0] - 2018-01-14
### Added
- `AudioInput` struct to manage input sensors such as microphones.
- `MicrophoneType` protocol for a hardware microphone to conform to.

### Changed
- Expose isRecording in the recorder
- Remove all processing code, this framework only deals with AudioIO now.

## [0.0.1] - 2017-11-28
### Added
- A recorder object that manages the recording input data
- A processor object that processes audio samples

### Changed