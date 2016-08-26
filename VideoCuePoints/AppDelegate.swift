//
//  AppDelegate.swift
//  VideoCuePoints
//
//  Created by Bryan Berger on 8/25/16.
//  Copyright © 2016 Bryan Berger. All rights reserved.
//

import Cocoa
import AVFoundation

var output:AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
var session:AVCaptureSession = AVCaptureSession()
var input:AVCaptureScreenInput = AVCaptureScreenInput()
var menu = NSMenu()
var timer = NSTimer()
var timeCountInSeconds:Int = 0

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, AVCaptureFileOutputRecordingDelegate {

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSApplication.sharedApplication().windows.last!.close()
        
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
        }
        
        menu.addItem(NSMenuItem(title: "Start Recording", action: #selector(AppDelegate.setupCameraSession(_:)), keyEquivalent: "R"))
        menu.addItem(NSMenuItem(title: "Add Cue Point", action: #selector(AppDelegate.addCuePoint(_:)), keyEquivalent: "C"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.sharedApplication().terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    func updateMenu() {
        
    }
    
    func addCuePoint(sender:AnyObject) {
        print("addCuePoint")
        
//        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
//        let path = documents.URLByAppendingPathComponent("votes").path!
//        
//        if let outputStream = NSOutputStream(toFileAtPath: path, append: true) {
//            outputStream.open()
//            let text = "some text"
//            outputStream.write(text)
//            
//            outputStream.close()
//        } else {
//            print("Unable to open file")
//        }
        
    }
    
    func countTime() {
        print(timeCountInSeconds)
        timeCountInSeconds += 1
    }
    
    func setupCameraSession(sender:AnyObject) {
        do {
            
            print("setupCameraSession")
            
            session = AVCaptureSession()
            session.sessionPreset = AVCaptureSessionPresetHigh
            
            input = AVCaptureScreenInput(displayID: CGMainDisplayID())
            input.cropRect = CGRectMake(0, 0, 0, 0)
            input.minFrameDuration = CMTimeMake(1, 30)
            input.capturesCursor = true
            input.capturesMouseClicks = true
            
            output = AVCaptureMovieFileOutput()
            
            
            let date = NSDateFormatter()
            date.dateFormat = "yyyy-mm-dd h.MM.ss a"
            let dateString = date.stringFromDate(NSDate())
            
            let outputPath = NSURL(fileURLWithPath: "/Users/bryanberger/Desktop/Recording " + dateString + ".mp4")
            let audioDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            
            if(session.canAddInput(input)) {
                session.addInput(input)
            }
            
            if(session.canAddOutput(output)) {
                session.addOutput(output)
            }
            
            if (session.canAddInput(audioInput)) {
                session.addInput(audioInput)
            }
            
            session.startRunning()
            output.startRecordingToOutputFileURL(outputPath, recordingDelegate: self)
            
            // timer for now
            NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(self.stop), userInfo: nil, repeats: false)
            
            // create timer
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(self.countTime), userInfo: nil, repeats: true)
            
        } catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    func stop() {
        NSLog("stop recording")
        output.stopRecording()
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didPauseRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        print("didPauseRecordingToOutputFileAtURL")
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        print("didStartRecordingToOutputFileAtURL")
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didResumeRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        print("didResumeRecordingToOutputFileAtURL")
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, willFinishRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        print("willFinishRecordingToOutputFileAtURL")
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        print("didFinishRecordingToOutputFileAtURL")
    }

    
    func printQuote(sender: AnyObject) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    


}

