//
//  ViewController.swift
//  VideoCuePoints
//
//  Created by Bryan Berger on 8/25/16.
//  Copyright © 2016 Bryan Berger. All rights reserved.
//

import Cocoa
import AVFoundation
//
//var output:AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
//var session:AVCaptureSession = AVCaptureSession()
//var input:AVCaptureScreenInput = AVCaptureScreenInput()

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        print("viewDidLoad")
        
        super.viewDidLoad()
       // setupCameraSession()
    }
    
    
//    lazy var cameraSession: AVCaptureSession = {
//        let s = AVCaptureSession()
//        s.sessionPreset = AVCaptureSessionPresetLow
//        return s
//    }()
    
//    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
//        let preview =  AVCaptureVideoPreviewLayer(session: self.cameraSession)
//        preview.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
//        preview.position = CGPoint(x: CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds))
//        preview.videoGravity = AVLayerVideoGravityResize
//        return preview
//    }()
//    
//    func setupCameraSession() {
//        do {
//            
//            print("testing")
//            
//            session = AVCaptureSession()
//            session.sessionPreset = AVCaptureSessionPresetHigh
//            
//            input = AVCaptureScreenInput(displayID: CGMainDisplayID())
//            input.cropRect = CGRectMake(0, 0, 0, 0)
//            input.minFrameDuration = CMTimeMake(1, 30)
//            input.capturesCursor = true
//            input.capturesMouseClicks = true
//            
//            output = AVCaptureMovieFileOutput()
//            let outputPath = NSURL(fileURLWithPath: "/Users/bryanberger/Desktop/capture.mov")
//            let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
//            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
//            
//            if(session.canAddInput(input)) {
//                session.addInput(input)
//            }
//            
//            if(session.canAddOutput(output)) {
//                session.addOutput(output)
//            }
//            
//            if (session.canAddInput(audioInput)) {
//                session.addInput(audioInput)
//            }
//                
//            session.startRunning()
//            output.startRecordingToOutputFileURL(outputPath, recordingDelegate: self)
//            
//            // timer for now
//            NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.stop), userInfo: nil, repeats: false)
//            
//        } catch let error as NSError {
//            NSLog("\(error), \(error.localizedDescription)")
//        }
//    }
//    
//    func stop() {
//        NSLog("stop recording")
//        output.stopRecording()
//    }
//    
//    func captureOutput(captureOutput: AVCaptureFileOutput!, didPauseRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
//        print("didPauseRecordingToOutputFileAtURL")
//    }
//    
//    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
//        print("didStartRecordingToOutputFileAtURL")
//    }
//    
//    func captureOutput(captureOutput: AVCaptureFileOutput!, didResumeRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
//        print("didResumeRecordingToOutputFileAtURL")
//    }
//    
//    func captureOutput(captureOutput: AVCaptureFileOutput!, willFinishRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
//        print("willFinishRecordingToOutputFileAtURL")
//    }
//    
//    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
//        print("didFinishRecordingToOutputFileAtURL")
//    }


    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

