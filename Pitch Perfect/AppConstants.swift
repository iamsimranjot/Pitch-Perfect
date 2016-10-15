//
//  AppConstants.swift
//  Pitch Perfect
//
//  Created by SimranJot Singh on 14/10/16.
//  Copyright © 2016 SimranJot Singh. All rights reserved.
//

struct AppConstants {
    
    static let audioFileName = "recordedVoice.wav"
    static let stopRecordingSegueIdentifier = "stopRecording"
    
    struct labels {
        
        static let Recording = "Recording in Progress"
        static let ReadyToRecord = "Tap to Record"
    }
    
    struct alerts {
        
        static let dismiss = "Dismiss"
        static let recordingAudioError = "Audio Recording Error"
        static let recordingUnsuccessful = "Recording Un-Successful"
        static let recordingUnsuccessfulMessage = "Something went wrong with your recording."
        static let audioSessionError = "Audio Session Error"
        static let audioRecorderError = "Audio Recorder Error"
        static let recordingDisabledTitle = "Recording Disabled"
        static let recordingDisabledMessage = "You've disabled Pitch Perfect from recording your microphone. Check Settings."
        static let audioFileError = "Audio File Error"
        static let audioEngineError = "Audio Engine Error"
    }
}
