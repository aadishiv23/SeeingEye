//
//  Detector.swift
//  SeeingEye
//
//  Created by Aadi Shiv Malhotra on 8/6/23.
//

import Foundation
import UIKit
import AVFoundation
import Vision
import SwiftUI

extension ViewController {
    
    // setupdetector
    // get path to model n load it
    func setupDetector() {
        _ = Bundle.main.url(forResource: "CrossBudV3", withExtension: "mlmodel")
        do {
            let visionModel = try VNCoreMLModel(for: CrossBudV3().model)
            //let visionModel = try VNCoreMLModel(for: AmpelPilot_2812rg().model)
            //let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL!))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch let error {
            print(error)
        }
    }
    
    // to process the results, implement completion handler detectoinDidCOmplete
    // check whether object detected in frame
    // if so call functoins to draw
    // since we draw on screen has to be done on main queueu
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async(execute: {
            //deteciton in list of dict
            // type VNObservatoin
            //if obj detection, extract to draw in extractDetections
            if let results = request.results {
                self.extractDetections(results)
            }
        })
    }
    
    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil

        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else { continue }
            
            // transformation
            // since they use diff
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
            // pray this math is right , why are the reference planes difference
            let transformBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
            
            let boxLayer = self.drawBoundingBox(transformBounds)
            print(observation.confidence)
            print(results.debugDescription)
            print(objectObservation.labels)
            DispatchQueue.main.async {
                self.detectionLayer.addSublayer(boxLayer)
            }

           
        }
        
       
    }
    
    func setupLayers() {
        detectionLayer = CALayer()
        detectionLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        self.view.layer.addSublayer(detectionLayer)
    }
    
    func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
    }
    
    func drawBoundingBox(_ bounds: CGRect) -> CALayer {
        print("here")
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 5.0
        boxLayer.borderColor = CGColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        boxLayer.cornerRadius = 4
       return boxLayer
        /*let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 10.0
        //boxLayer.borderColor = CGColor.init(red: 3.0, green: 5.0, blue: 5.0, alpha: 1.0)
        // some reason only works this way
        boxLayer.borderColor = CGColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        //dont work
       // boxLayer.borderColor = UIColor.blue.cgColor

        boxLayer.cornerRadius = 5
        //print(boxLayer.frame.width)
        return boxLayer*/
    }
    
  
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        
        do {
            try imageRequestHandler.perform(self.requests) // schedule vision requests to be performed
        } catch let error {
            print(error)
        }
    }
    
}

//vnimagereqhandler
// get frame from image buffer
// can perform object detection by calling method perform on handler w/ requests as arg


