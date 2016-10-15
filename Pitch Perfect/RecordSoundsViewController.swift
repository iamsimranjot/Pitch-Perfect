//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by SimranJot Singh on 13/10/16.
//  Copyright © 2016 SimranJot Singh. All rights reserved.
//

import UIKit
import  AVFoundation

class RecordSoundsViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    //MARK: Properties
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    private var recordingEnabled: Bool! = false
    
    //MARK:: Enum
    
    enum RecordingState { case WaitingToRecord, Recording }
    
    //MARK: LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Congigure Audio Session
        configureAudioSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         configureUI(recordingState: .WaitingToRecord)
    }

    //MARK: IBActions
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        
        guard recordingEnabled == true else {
            
            showAlert(title: AppConstants.alerts.recordingDisabledTitle, errorMessage: AppConstants.alerts.recordingDisabledMessage)
            return
        }
        
        configureUI(recordingState: .Recording)
        
        do {
            recordedAudio = RecordedAudio(filePathUrl: createAudioFilePath())
            audioRecorder = try AVAudioRecorder(url: recordedAudio.filePathUrl as URL, settings: [:])
            audioRecorder.delegate = self
        } catch {
            
            showAlert(title: AppConstants.alerts.audioRecorderError, errorMessage: String(describing: error))
        }
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {

        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    //MARK: Helper Methods
    
    private func createAudioFilePath() -> NSURL {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        let documentsDirectory = paths[0]
        let audioURL = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent(AppConstants.audioFileName)!
        return audioURL as NSURL
    }
    
    private func configureAudioSession(){
        
        let session = AVAudioSession.sharedInstance()
        do {
            
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            try  session.setActive(true)
            session.requestRecordPermission{ (granted) in
                self.recordingEnabled = granted
            }
        } catch {
            
            showAlert(title: AppConstants.alerts.audioSessionError, errorMessage: String(describing: error))
        }
    }
    
    private func configureUI(recordingState: RecordingState) {
        
        switch recordingState {
            
        case .WaitingToRecord:
            recordingLabel.text = AppConstants.labels.ReadyToRecord
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            
        case .Recording:
            recordingLabel.text = AppConstants.labels.Recording
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        }
    }
    
    func showAlert(title: String, errorMessage: String) {
        
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AppConstants.alerts.dismiss, style: .default, handler: { (UIAlertAction) in
            self.configureUI(recordingState: .WaitingToRecord)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: prepareForSegue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == AppConstants.stopRecordingSegueIdentifier) {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! RecordedAudio
            playSoundsVC.receivedAudioURL = recordedAudioURL
        }
    }
}

//MARK: AVAudioRecorderDelegate Extension

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
            
            self.performSegue(withIdentifier: AppConstants.stopRecordingSegueIdentifier, sender: recordedAudio)
            
        }else{
            
            showAlert(title: AppConstants.alerts.recordingUnsuccessful, errorMessage: AppConstants.alerts.recordingUnsuccessfulMessage)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        
        if let error = error {
            
            showAlert(title: AppConstants.alerts.recordingAudioError, errorMessage: error.localizedDescription)
        }
        
    }
}

