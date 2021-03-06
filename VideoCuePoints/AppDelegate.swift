//
//  AppDelegate.swift
//  VideoCuePoints
//
//  Created by Bryan Berger on 8/25/16.
//  Copyright © 2016 Bryan Berger. All rights reserved.
//

import Cocoa
import AVFoundation

var viewController:NSWindowController = NSWindowController()
var output:AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
var session:AVCaptureSession = AVCaptureSession()
var input:AVCaptureScreenInput = AVCaptureScreenInput()
var menu = NSMenu()
var recordingDirectory:String = ""
var currentRecordingDateString:String = ""
var isRecording:Bool = false
var cuePoints:[Int] = []

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, AVCaptureFileOutputRecordingDelegate {
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // get preferences
        NSUserDefaults.standardUserDefaults()
        
        // close ViewController
        //NSApplication.sharedApplication().windows.last!.close()
        let storyboard:NSStoryboard = NSStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateControllerWithIdentifier("MainWindowController") as! NSWindowController        
        // viewController.showWindow(self)

        // setup
        createMenu()
        createRecordingsDirectory()
    }
    
    func createMenu() {
        // status bar menu item icon
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
        }

        // add items
        menu.autoenablesItems = false
        menu.addItem(NSMenuItem(title: "Start Recording", action: #selector(setupCameraSession(_:)), keyEquivalent: "R"))
        menu.addItem(NSMenuItem(title: "Add Cue Point", action: #selector(addCuePoint(_:)), keyEquivalent: "C"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Preferences...", action: #selector(showPreferencesView(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem(title: "Show Recordings...", action: #selector(showRecordingDirectoryInFinder(_:)), keyEquivalent: "S"))
        menu.addItem(NSMenuItem.separatorItem())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.sharedApplication().terminate(_:)), keyEquivalent: "q"))
        
        // disable cue point item until recording starts
        menu.itemAtIndex(1)?.enabled = isRecording
        
        statusItem.menu = menu
    }
    
    func showPreferencesView(sender:NSMenuItem) {
        viewController.showWindow(self)
    }
    
    func createRecordingsDirectory() {
        do {
        
            let homeDirectory = NSHomeDirectory()
            recordingDirectory = homeDirectory + "/GA Video Recordings/"
            
            if (!NSFileManager.defaultManager().fileExistsAtPath(recordingDirectory)) {
                try NSFileManager.defaultManager().createDirectoryAtPath(recordingDirectory, withIntermediateDirectories: false, attributes: nil)
            }
        } catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    func updateMenu() {
        if(isRecording) {
            menu.itemAtIndex(1)?.enabled = isRecording
            menu.itemAtIndex(0)?.title = "Stop Recording"
            menu.itemAtIndex(0)?.action = #selector(self.stopRecording(_:))
            
        } else {
            menu.itemAtIndex(1)?.enabled = isRecording
            menu.itemAtIndex(0)?.title = "Start Recording"
            menu.itemAtIndex(0)?.action = #selector(self.setupCameraSession(_:))
        }
    }
    
    func showRecordingDirectoryInFinder(sender:AnyObject) {
        NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: recordingDirectory)
    }
    
    func addCuePoint(sender:AnyObject) {
        if(isRecording) {
            do {
                //let now = String(format: "%.0f", round(CMTimeGetSeconds(output.recordedDuration)))
                let now = Int(CMTimeGetSeconds(output.recordedDuration))
                cuePoints.append(now)
                
                let data = try NSJSONSerialization.dataWithJSONObject(cuePoints, options: .PrettyPrinted)
                let string = String(data: data, encoding: NSUTF8StringEncoding)
                
                //writeToFile(string!)
                try string!.writeToFile(recordingDirectory + "Cue Points " + currentRecordingDateString + ".json", atomically: false, encoding: NSUTF8StringEncoding);
            } catch let error as NSError {
                NSLog("\(error), \(error.localizedDescription)")
            }
        }
    }
    
    func writeToFile(content: String) {
        
        let contentToAppend = content
        let filePath = recordingDirectory + "Cue Points " + currentRecordingDateString + ".log"
        
        //Check if file exists
        if let fileHandle = NSFileHandle(forWritingAtPath: filePath) {
            //Append to file
            fileHandle.seekToEndOfFile()
            fileHandle.writeData(contentToAppend.dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        else {
            //Create new file
            do {
                try contentToAppend.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
            } catch {
                print("Error creating \(filePath)")
            }
        }
    }

    
    func setupCameraSession(sender:AnyObject) {
        do {
            print("setupCameraSession")
            
            session = AVCaptureSession()
            session.sessionPreset = AVCaptureSessionPresetHigh // video quality
            
            input = AVCaptureScreenInput(displayID: CGMainDisplayID())
            input.cropRect = CGRectMake(0, 0, 0, 0)
            input.minFrameDuration = CMTimeMake(1, 30)
            input.capturesCursor = true
            input.capturesMouseClicks = true
            
            output = AVCaptureMovieFileOutput()
            
            let date = NSDateFormatter()
            date.dateFormat = "yyyy-mm-dd h.MM.ss a"
            let dateString = date.stringFromDate(NSDate())
            currentRecordingDateString = dateString

            let outputPath = NSURL(fileURLWithPath: recordingDirectory + "Recording " + currentRecordingDateString + ".mov")
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
            
            // start running
            session.startRunning()
            output.startRecordingToOutputFileURL(outputPath, recordingDelegate: self)
            isRecording = true
            
            // update menu items
            updateMenu()
        } catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
            isRecording = false
        }
    }
    
    func stopRecording(sender: NSMenuItem) {
        NSLog("stop recording")
        
        output.stopRecording()
        isRecording = false
        
        // remove all cuePoints
        cuePoints.removeAll()
        
        // update menu items
        updateMenu()
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

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}