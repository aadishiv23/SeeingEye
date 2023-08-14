//
//  HostedViewController.swift
//  SeeingEye
//
//  Created by Aadi Shiv Malhotra on 8/2/23.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation
import Vision

// def instance var request
// aray contains VN reqest which sends frames to model

// sbd
// whenever new frame is captured by capure sessoin
// method captureoutput is called and frame is added to buffer
class ViewController : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var permissionGranted = false
    
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil  // for view dimensions
    
    // for the detector
    private var videoOutput = AVCaptureVideoDataOutput()
    
    // def instance var request
    // aray contains VN reqest which sends frames to model
    var requests = [VNRequest]()
    var detectionLayer : CALayer! = nil
    
    

    override func viewDidLoad() {
        //print("here")
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            guard permissionGranted else {return}
            NotificationCenter.default.addObserver(self, selector: #selector(self.appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.appWillTerminate), name: UIApplication.willTerminateNotification, object: nil)
            self.setupCaptureSession()
            self.setupLayers()
            self.setupDetector()
            self.captureSession.startRunning()
            
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRect = UIScreen.main.bounds
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.width, height: screenRect.height)
        
        switch UIDevice.current.orientation {
            // home button on top
        case UIDeviceOrientation.portraitUpsideDown:
            self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
            
        case UIDeviceOrientation.portrait:
            self.previewLayer.connection?.videoOrientation = .portrait
            
        case UIDeviceOrientation.landscapeLeft:
            self.previewLayer.connection?.videoOrientation = .landscapeRight
            
        case UIDeviceOrientation.landscapeRight:
            self.previewLayer.connection?.videoOrientation = .landscapeLeft
            
        default:
            break
        }
        
        // detector
        updateLayers()

    }
    
    func checkPermission() {
        print("2")
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .denied:
            requestPermission()
        default:
            permissionGranted = true
        }
    }

    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    
    func setupCaptureSession() {
        // access camera
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else {return}
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {return}
        
        guard captureSession.canAddInput(videoDeviceInput) else {return}
        captureSession.addInput(videoDeviceInput)
        
        // Preview layer
        //screenRect = view.window?.windowScene.bounds
        screenRect = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.width, height: screenRect.height)
        // how layer displays video content in bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        previewLayer.connection?.videoOrientation = .portrait
        
        // set classview controller as buffer delegate and connect output to capture session
        // delegate is why we extend class
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        
        
        videoOutput.connection(with: .video)!.videoOrientation = .portrait
        
        // setup done on sessoin queueu but updates to ui done on main queue
        // add preview layer to root view layer on main queue
        DispatchQueue.main.async { [weak self] in
            self!.view.layer.addSublayer(self!.previewLayer)
        }
    }
    
    // Function to clean up and stop detection when the app is about to enter the background
       @objc func appWillResignActive() {
           stopDetectionAndCleanup()
       }

       // Function to clean up and stop detection when the app is about to terminate
       @objc func appWillTerminate() {
           stopDetectionAndCleanup()
           cleanupVision() // Cleanup Vision-related resources
       }

       // Cleanup Vision-related resources
       func cleanupVision() {
           stopDetectionAndCleanup()
           detectionLayer.sublayers?.removeAll()
       }
    
    // Function to stop detection and clean up resources
    func stopDetectionAndCleanup() {
        // Stop Vision-based detection
        captureSession.stopRunning()

        // Clear detection layers
        detectionLayer.sublayers?.forEach { $0.removeFromSuperlayer() }

        // Release any resources associated with Vision (if needed)
        requests.removeAll() // Clear any VNRequests
    }
}

struct HostedViewController : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}




// contorller has two tasks here
// 1 - checks if app has permission
// if so set ups capture session to present field


// have to set layer
/*
 foundation is the views underlying layer - self.view.layer
 we added previewLayer which gives camera feed
 now on this same level add deteciton layer
 contains all the bounding boxes
 each boundinf box is a layer which is added to detectoin layer
 
 
    self.view.layer
        /       \
 previewLayer   detectionLayer
 */
