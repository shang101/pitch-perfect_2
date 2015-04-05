//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Shirley Hang on 3/25/15.
//  Copyright (c) 2015 shirley. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var resumeButton: UIButton!

    
    var audioRecorder:AVAudioRecorder!
    
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingInProgress.text = "Tap to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //disable all the three buttons - pause, stop, and
    //resume
    override func viewWillAppear(animated: Bool)
    {
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordButton.enabled = true
    }
    //recording audio with file name associated with current date time
    @IBAction func recordAudio(sender: UIButton)
    {
        recordingInProgress.hidden = false
        stopButton.hidden = false
        pauseButton.hidden = false
        recordButton.enabled = false
        
        recordingInProgress.text = "Recording in progress"
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }
    //finish recording
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        if (flag)
        {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        recordingInProgress.text = "Tap to Record"
    }
    //prepare to pass data to the next screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    //stop recording
    @IBAction func stopAudio(sender: UIButton)
    {
        recordButton.enabled = true
        
        audioRecorder.stop()
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    //pause recording
    @IBAction func pauseAudio(sender: UIButton)
    {
        pauseButton.hidden = true
        resumeButton.hidden = false
        audioRecorder.pause()
    }
    //resume recording
    @IBAction func resumeAudio(sender: UIButton)
    {
        resumeButton.hidden = true
        stopButton.hidden = false
        audioRecorder.record()
    }
}

