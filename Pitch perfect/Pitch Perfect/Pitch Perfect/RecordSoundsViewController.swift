//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Wael Farouk on 4/12/15.
//  Copyright (c) 2015 Wael Farouk. All rights reserved.
//

import UIKit
import AVFoundation




class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate{

    @IBOutlet weak var Recordingprogress: UILabel!
    @IBOutlet weak var stopbutton: UIButton!
    @IBOutlet weak var recordbutton: UIButton!
    
   var recordedAudio: RecordedAudio!
   var audioRecorder:AVAudioRecorder!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
     stopbutton.hidden = true
        
    }
    

    
    @IBAction func RecordAudio(sender: UIButton) {
        // TODO: show text "recording in progress"
        Recordingprogress.hidden = false
        stopbutton.hidden = false
        recordbutton.enabled = false
        // TODO: record user's voice
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Setup audio session
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
      
        
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
       
       if (flag) {
        
        recordedAudio = RecordedAudio()
        recordedAudio.filpathurl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
       
            
        }else{
            
        println("Recording not done successfuly")
        recordbutton.enabled = true
        stopbutton.hidden = true
        
        }
   
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier) == "stopRecording" {
            
            let playSoundsVC : PlaySoundViewControlerViewController = segue.destinationViewController as! PlaySoundViewControlerViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
            
        }
        
    }

    
    
    @IBAction func stopAudio(sender: AnyObject) {
        
        Recordingprogress.hidden = true
        recordbutton.enabled = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

}

