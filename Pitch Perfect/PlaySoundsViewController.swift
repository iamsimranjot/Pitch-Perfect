//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by SimranJot Singh on 13/10/16.
//  Copyright © 2016 SimranJot Singh. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    //MARK: Properties
    
    var receivedAudioURL: RecordedAudio!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    //MARK: Enum
    
    enum buttonType: Int {
        case Slow = 0,
        Fast,
        Chipmunk,
        Vader,
        Echo,
        Reverb
    }
    
    //MARK: LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI(playState: .NotPlaying)
        
        //Add selectors for Interrupts, Route Changes and Calls
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioInterrupt(notification:)), name:NSNotification.Name.AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioRouteChange(notification:)), name:NSNotification.Name.AVAudioSessionRouteChange, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.addObserver(self, selector: #selector(handleAudioMediaServiceReset(notification:)), name:NSNotification.Name.AVAudioSessionMediaServicesWereReset, object: AVAudioSession.sharedInstance())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //stopAudio function is called here so that the audio does not keep playing on the RecordSoundsViewController when user clicked the
        //back button while playing
        
        stopAudio()
        audioEngine = nil
        stopTimer = nil
        audioPlayerNode = nil
        
        //Remove selectors for Interrupts, Route Changes and Calls
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionRouteChange, object: AVAudioSession.sharedInstance())
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionMediaServicesWereReset, object: AVAudioSession.sharedInstance())
    }

    //MARK: IBActions
    
    @IBAction func playSoundForButton(_ sender: UIButton){
        
        switch (buttonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        }
        
        configureUI(playState: .Playing)
        
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton){
        stopAudio()
    }
    
    //MARK: Notification Selectors
    
    func handleAudioInterrupt(notification: NSNotification){
        
        if let interruptionValue = (notification.userInfo)?["AVAudioSessionInterruptionTypeKey"] as? NSNumber {
            if let interruptionType = AVAudioSessionInterruptionType(rawValue: interruptionValue.uintValue) {
                switch interruptionType {
                case .began:
                    stopAudio()
                default:
                    break
                }
            }
        }

    }
    
    func handleAudioRouteChange(notification: NSNotification){
        
        if let changeValue = (notification.userInfo)?["AVAudioSessionRouteChangeReasonKey"] as? NSNumber {
            if let changeType = AVAudioSessionRouteChangeReason(rawValue: changeValue.uintValue) {
                switch changeType {
                case .oldDeviceUnavailable, .newDeviceAvailable:
                    stopAudio()
                default:
                    break
                }
            }
        }
    }
    
    func handleAudioMediaServiceReset(notification: NSNotification){
        
        setupAudio()
        stopAudio()
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            
            self.stackView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
        }) { (UIViewControllerTransitionCoordinatorContext) in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.stackView.transform = CGAffineTransform.identity
            })
        }
    }
    
}
