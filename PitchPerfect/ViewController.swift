//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Pinak Jalan on 5/13/17.
//  Copyright © 2017 Pinak Jalan. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UILabel!
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        
    }

    func switchLabelsAndButtons(isRecording: Bool) {
        recordButton.text = isRecording ? "Recording in progress" : "Tap to record"
        record.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
    }
    
    @IBAction func ButtonPressed(_ sender: Any) {
        //print("Button was pressed, yo.")
        //Changed code and abstracted it into a method.
        switchLabelsAndButtons(isRecording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordingPressed(_ sender: Any) {
        switchLabelsAndButtons(isRecording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    
    //This is is a delegate function using a segue to do stuff.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
        performSegue(withIdentifier: "stopRecordingPressed", sender: audioRecorder.url)
        }
        else {
            print("Not working as expected")
 
        }
    }
    //We go from View Controller to View controller using a segue, not a button to view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //This is called when you are transitioning from one UIViewController to another, in prep for the second one
        if segue.identifier == "stopRecordingPressed"
        {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            
            //The line below actually gives the recorded sound to the second view controller which is why we are setting all of these prooperties once we press the stop recording button
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
        
    }
    
}




