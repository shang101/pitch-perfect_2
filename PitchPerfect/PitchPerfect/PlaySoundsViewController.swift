//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Shirley Hang on 3/25/15.
//  Copyright (c) 2015 shirley. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController
{
    var audioPlayer:AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //user the audioPlayer to play audio, stop any previous audio sound effects
    func playAudio()
    {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    //set the slow speed to play the audio using the audio player
    @IBAction func playSlowAudio(sender: UIButton)
    {
        audioPlayer.rate = 0.5
        playAudio()
    }
    //set the fast speed to play the audio using the audio player
    @IBAction func playFastAudio(sender: UIButton)
    {
        audioPlayer.rate = 1.5
        playAudio()
    }
    
    //stop the audio playing from other sound effects
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    //Chipmunk button is pressed
    //set the chipmunk pitch to play audio
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
    }
    //DarthVader button is pressed
    //set the DarthVader pitch to play audio
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    //stop and reset the audio Engine, use the audio engine to process and play the audio
    //with different pitch
    func playAudioWithVariablePitch(pitch: Float)
    {
        audioEngine.stop()
        audioEngine.reset()
        
        audioPlayer.stop()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
}
